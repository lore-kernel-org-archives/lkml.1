Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXBBMvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXBBMvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBBMvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:51:43 -0500
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:62568 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387AbXBBMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:51:43 -0500
Message-ID: <45C333D7.3000205@l4x.org>
Date: Fri, 02 Feb 2007 13:51:35 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0pre (Windows/20070130)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: lirc@bartelmus.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lirc: remove backwards compatibility macro obfuscation
 (Was: Free Linux Driver Development!)
References: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>	 <45C31C19.5040200@l4x.org> <84144f020702020332wee0aa69v19d09768f5643779@mail.gmail.com>
In-Reply-To: <84144f020702020332wee0aa69v19d09768f5643779@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 2/2/07, Jan Dittmer <jdi@l4x.org> wrote:
>> Pekka, it would be better if you could sort out most of the
>> basic issues with lirc directly with the developers of lirc
>> and then prepare a complete patch series and post that to
>> lkml. Incrementally adding one driver after another. Posting
>> patches to non-existent sources to lkml is pointless. First
>> create a discussion base, please.
> 
> What discussion base? You need to get rid of the cruft anyway and now
> you have patch to do that. I am not volunteering to sort out _all_ the
> issues.

I really really welcome your efforts - no doubt.

I wanted to express that the patches you posted are simply not
suitable for lkml discussion as there was no full patchset for
lirc for review posted, prior to your patches.

Normal process for new features (and lirc is a new feature so
far lkml is concerned) is like (as I understand it):
  1. post full patchset
  2. duck
  3. receive criticism & patches
  4. integrate results from 3
  5. goto 1
You started at 3. It would be better to start with the whole
picture at 1.

I hope I made myself clearer now.

Jan
