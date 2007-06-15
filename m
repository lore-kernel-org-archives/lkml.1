Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbXFOFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbXFOFjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXFOFjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:39:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbXFOFjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:39:06 -0400
To: Bron Gondwana <brong@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132121.04532.dhazelton@enter.net>
	<orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132304.21984.dhazelton@enter.net>
	<20070614112329.3645c397@the-village.bc.nu>
	<20070614103846.GA7902@elte.hu>
	<or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614195517.GA4933@elte.hu>
	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 02:38:41 -0300
In-Reply-To: <20070615041149.GA6741@brong.net> (Bron Gondwana's message of "Fri\, 15 Jun 2007 14\:11\:49 +1000")
Message-ID: <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:

> #define Dell CFG_FAVOURITE_VENDOR

> A Dell desktop machine is a piece of hardware.  The manufacturer has the
> source code (hypothetically) to the BIOS.  The BIOS is required for the
> machine to boot and run Linux.

> Riddle me this (especially Alexandre, I'm just latching on to Ingo's
> post because it has the right hook to grab) - are Dell required to give
> out the source to the bios to enable people to have the same rights Dell
> engineers do to modify the behaviour of the system?

What is the license for the bios?  Does it say anything about 'no
further restrictions on the freedoms to modify and share the
software'?

Does it include any mechanisms to stop people from booting modified
versions of the Linux that ships with the machine?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
