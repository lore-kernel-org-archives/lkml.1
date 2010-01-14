Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431Ab0ANSFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0ANSFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937Ab0ANSFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:05:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36428 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab0ANSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:05:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B4F5CC8.7020107@s5r6.in-berlin.de>
Date: Thu, 14 Jan 2010 19:04:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] MAINTAINERS: Document new "Q:" patchwork queue
 type
References: <cover.1263452908.git.joe@perches.com>	 <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com>	 <4B4F20B3.703@s5r6.in-berlin.de>  <4B4F2402.9040008@s5r6.in-berlin.de> <1263490722.1903.12.camel@Joe-Laptop.home>
In-Reply-To: <1263490722.1903.12.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2010-01-14 at 15:02 +0100, Stefan Richter wrote:
>> Stefan Richter wrote:
>>> The proposed entry type is somewhat redundant:
>> PS:  Make sure that patchwork.kernel.org and patchwork.ozlabs.org are
>> mentioned in our process-related documentation, and you are done.  No
>> need for more MAINTAINERS churn just for that.
> 
> Many lists are not using patchwork.

All lists which do use patchwork are listed on patchwork.kernel.org and
patchwork.ozlabs.org.  So, add a paragraph on them in
Documentation/HOWTO and you are done.

The listings at patchwork.kernel.org and patchwork.ozlabs.org are always
current.  Your manual copy in the kernel source won't be.

See?  I just saved you and others quite some time.  You could spend it
for example to helpgetting our regressions count down.

> Micropatches to MAINTAINERS are preferred because of rate of change.

Useless micropatches do _not_ make one look productive.
-- 
Stefan Richter
-=====-==-=- ---= -===-
http://arcgraph.de/sr/
