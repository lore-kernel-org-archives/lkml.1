Return-Path: <linux-kernel-owner+w=401wt.eu-S934843AbYEBMka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbYEBMka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761112AbYEBMkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:40:22 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39235 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831AbYEBMkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:40:21 -0400
Message-ID: <481B0B71.4090501@s5r6.in-berlin.de>
Date: Fri, 02 May 2008 14:39:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Subject: Re: Who reverted 2.6.25 - stats
References: <alpine.LNX.1.10.0805021332510.6463@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805021332510.6463@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> One thing I noticed is that reverts are not always marked with the word 
> "revert" in the summary line even though it normally would be,

IMO the summary line of a fix should tell what is being fixed.  The
changelog can then go on to explain how the fix works.  For example, by
reverting all or parts of a previous commit.
-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/
