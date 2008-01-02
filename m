Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYABVsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYABVsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYABVsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:48:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58052 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYABVsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:48:10 -0500
Date: Wed, 2 Jan 2008 22:48:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use __u64 in aligned_u64's definition
In-Reply-To: <alpine.LFD.1.00.0801021341070.3010@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801022243450.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.1.00.0801021251040.32517@woody.linux-foundation.org>
 <Pine.LNX.4.64.0801022225460.14900@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.1.00.0801021341070.3010@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 2 2008 13:42, Linus Torvalds wrote:
>On Wed, 2 Jan 2008, Jan Engelhardt wrote:
>>
>> A cleanup. Or perhaps a precautionary change, should unsigned long
>> long ever become something that is not 64-bit. It was intended for
>> 2.6.25 actually. You don't take patches this early, do you?
>
>Yeah, no, I don't take patches early. I've considered setting up another 
>branch for early patches, but decided that I'm (a) lazy and (b) better off 
>encouraging people in the late -rc timeframe to just concentrate on the 
>-rc's, not the next version.
>
Well you can also apply it right now, then it's done and life can go on.


Jan
