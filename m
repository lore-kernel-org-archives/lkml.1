Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbYBOS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbYBOS0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbYBOS0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:26:03 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42489 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbYBOS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:26:00 -0500
Date: Fri, 15 Feb 2008 10:46:17 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
In-reply-to: <p7363wq1nk2.fsf@bingen.suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802151046.17710.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802150127.21247.yinghai.lu@sun.com>
 <p7363wq1nk2.fsf@bingen.suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 03:11:57 am Andi Kleen wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> >
> > [akpm@linux-foundation.org: many fixes and cleanups]
> > Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> > Signed-off-by: Andi Kleen <ak@suse.de>
> > Tested-by: Andi Kleen <ak@suse.de>
> 
> iirc it really was 
> Tested-and-didnt-pass-test-by: Andi Kleen 
> unfortunately. I have not rechecked recently, but on the one Intel
> box the original patch and the other mcfg heuristics removed didn't work.

i can not find the one that disable MMIO for BAR probing...

YH

