Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXEADl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXEADl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXEADl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:41:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45477 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXEADl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:41:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com>
	<4636A332.2070101@zytor.com>
	<m1odl51dci.fsf@ebiederm.dsl.xmission.com>
	<20070501034612.GK25929@bingen.suse.de>
	<m1hcqx1bvg.fsf@ebiederm.dsl.xmission.com>
	<4636B227.2020403@zytor.com>
Date: Mon, 30 Apr 2007 21:41:29 -0600
In-Reply-To: <4636B227.2020403@zytor.com> (H. Peter Anvin's message of "Mon,
	30 Apr 2007 20:21:11 -0700")
Message-ID: <m1d51l1a8m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> Andi Kleen <ak@suse.de> writes:
>> 
>>>> Not that the x86 BIOS is bad.  It is nearly a marvel in it's simplicity
>>>> and ubiquitousness, 
>>> Simplicity? That must be why x86 motherbords are shipping with (compressed) 
>>> 8MB BIOS flash chips now.
>> 
>> Those would be 8 megabit chips, and those would be server motherboards
>> you are looking.  Most likely the ones that are starting to think ahead
>> to EFI support.
>> 
>
> No, 4-8 MB chips are starting to be deployed, but the bulk is for
> OS-less applications.

I don't doubt that there are some rare systems with very large
capacity flash chips.  However the size of all BIOS chips are measured
in bits.  Anyone talking about the capacity of BIOS chips in bytes
and not bits always raises a red flag with me because that is a very
common mistake.

I would be very surprised if the high volume commodity boards have
exceeded 8 megabits.

Eric
