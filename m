Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYCFWZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYCFWZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYCFWZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:25:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44710 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYCFWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:25:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47D06F31.2050003@s5r6.in-berlin.de>
Date: Thu, 06 Mar 2008 23:24:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/16] ieee1394: replace remaining __FUNCTION__ occurrences
References: <1204770294.14154.43.camel@brick>
In-Reply-To: <1204770294.14154.43.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__

Committed to linux1394-2.6.git.  Thanks,
-- 
Stefan Richter
-=====-==--- --== --==-
http://arcgraph.de/sr/
