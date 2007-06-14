Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXFNA4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXFNA4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 20:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbXFNA4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 20:56:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbXFNA4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 20:56:22 -0400
To: Bongani Hlope <bhlope@mweb.co.za>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
	<or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140215.54179.bhlope@mweb.co.za>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 21:55:52 -0300
In-Reply-To: <200706140215.54179.bhlope@mweb.co.za> (Bongani Hlope's message of "Thu\, 14 Jun 2007 02\:15\:53 +0200")
Message-ID: <or4plbl5gn.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Bongani Hlope <bhlope@mweb.co.za> wrote:

> On Thursday 14 June 2007 01:49:23 Alexandre Oliva wrote:

>> if you distribute copies of such a program, [...]
>> you must give the recipients all the rights that you have

>> So, TiVo includes a copy of Linux in its DVR.

> And they give you the same right that they had, which is obtain free software 
> that you can modify and redistribute. There's nothing in there that says they 
> should give you the tools they used after they received the software, which 
> is what you seem to be looking for.

Can they modify the software in their device?

Do they pass this right on?

>> TiVo retains the right to modify that copy of Linux as it sees fit.

>> It doesn't give the recipients the same right.

> It does, can't you modify their kernel source?

It's not the kernel source.  That's not where the TiVo anti-tampering
machinery blocks modifications.

It's about that copy of the kernel that ships in the device in object
code.  That's the one that TiVo customers ought to be entitled to
modify, if TiVo can modify it itself.

> Where does it say you should be able to run you modifications on the
> same hardware?

Where it says that you should pass on all the rights that you have.

While TiVo retains the ability to replace, upgrade, fix, break or make
any other change in the GPLed software in the device, it ought to pass
it on to its customers.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
