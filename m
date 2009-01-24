Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZAXW3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZAXW3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 17:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZAXW3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 17:29:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59995 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZAXW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 17:29:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <497B9636.9090209@s5r6.in-berlin.de>
Date: Sat, 24 Jan 2009 23:29:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 6/7] ieee1394: sbp2: add workarounds for 2nd and 3rd
 generation iPods
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <tkrat.9cf7aabbf7a0af4a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.9cf7aabbf7a0af4a@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> According to https://bugs.launchpad.net/bugs/294391
>   - 3rd generation iPods need the "fix capacity" workaround after all
>     (apparently they crash after the last sector was accessed),

Bug update:  This workaround alone does not prevent I/O errors later on.
-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/
