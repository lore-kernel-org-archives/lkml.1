Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXAWTZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXAWTZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXAWTZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:25:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:59478 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbXAWTZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EENNpQTRbzH2If+7LMeLkCbH1w05B++Oed5+CrP6XV1zw4qwSC/3l5vpjS+31S9+BF9pGP9oW8ibaS0NLo/N9sW7HnB8ckt3B/04fdOEmOpBlNGHsrrU3ae+Pu+L9x7x3hh08ncNllgvDzYakRQPXG3buGt/eUMWVtLbShcW0IY=
Message-ID: <8355959a0701231125y36cad93eo7075aa1889674b3e@mail.gmail.com>
Date: Wed, 24 Jan 2007 00:55:37 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [Proposal] 2.6.18-stable release plans?
Cc: lkml <linux-kernel@vger.kernel.org>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <45B648CA.3020507@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B53722.9030206@redhat.com>
	 <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com>
	 <8355959a0701230538m2f1201b6u49853e65d4c69a57@mail.gmail.com>
	 <45B648CA.3020507@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>
> This would be hard to organize and support. There are news sites like
> LWN which give outlines of important kernel changes, and there are
> mailinglists or community sites for architectures or driver subsystems
> if you are interested in special platforms or drivers, and there is the
> git repository metadata (via gitweb or directly from a locally cloned
> git repo).

That's the problem all about. I don't have problems finding info about
a kernel feature or about a driver patch. But even for me it takes
some time to figure it out. (I don't work only with Linux......do work
with Mac OS, and Solaris too. But less of Windows!)

Am talking from the Linux users point of view (who need to know deep
about the Kernel development, etc. Imagine, a student or a
professional who wants to build a kernel with a patch for a i686
machine? Can't we simplify this at www.kernel.org home page instead of
user being lost in searching on Google or wherever?

> It's also not only a question of who writes such release notes, but also
> of who the intended audience is. How fine-grained should the release
> notes be?

I would like to contribute here, in any way. Fine graining might be a
problem. But we can give info in general? Example, if patch-2.6.19.3
comes out - simply we can say as *x86 32/64* based on the weightage of
fixes in that patch. What do you say?

> Anyway --- if in doubt, your distributor's current kernel is the best one.

I never depend on a distributor's kernel, especially Fedora has a
Generic one with many things enabled into the kernel. The moment I
install a distro....my hands would be itchy to build my own kernel
which is very specific to my H/W. No less or more. In this way I can
live with my best made kernel ;-)


[OT] Some posts I send does not appear on LKML. Even this one, I
couldn't find on list :( What might be the problem?

> Stefan Richter

Thanks,

~Akula2
