Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZGRGua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZGRGua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZGRGuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:50:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42903 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZGRGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:50:24 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <1247868130.8334.40.camel@localhost.localdomain>
	<87eisfvtzv.fsf@basil.nowhere.org>
	<1247871284.8334.42.camel@localhost.localdomain>
	<87ab32wmkv.fsf@basil.nowhere.org>
Date: Sat, 18 Jul 2009 08:50:23 +0200
In-Reply-To: <87ab32wmkv.fsf@basil.nowhere.org> (Andi Kleen's message of "Sat, 18 Jul 2009 08:07:44 +0200")
Message-ID: <87ws66v61c.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> john stultz <johnstul@us.ibm.com> writes:
>>
>> Hrmm. Can we deprecate the old method and push glibc to use the new one?
>
> That would break every old 64bit executable. Also not there are programs

s/not/note/

> who don't use glibc.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
