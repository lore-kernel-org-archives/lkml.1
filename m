Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYEEHB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYEEHB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYEEHBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:01:49 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:65495 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753097AbYEEHBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:01:48 -0400
Message-ID: <481EB11C.6070902@seznam.cz>
Date: Mon, 05 May 2008 09:02:52 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
Subject: Re: Microblaze patches V2
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <1209954637.5798.76.camel@localhost>
In-Reply-To: <1209954637.5798.76.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

I used git-send command for it. I'll fix bug and send third version.

Entry.S and others will at the end of set.

M


> Hi Michal,
> 
> On Sun, 2008-05-04 at 13:40 +0200, monstr@seznam.cz wrote:
> 
>> this is second set of patches. I fixed almost all bugs which
>> were reported in your emails.
> 
> Thanks for your work.
> 
> Maybe I missed it, but I didn't see entry.S, head.S, ptrace.c, and a few
> others?
> 
> John
