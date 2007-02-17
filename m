Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXBQVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXBQVPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbXBQVPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:15:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:56027 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922AbXBQVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P5T9Pfw4JS3w7WtKO+VWXJaX53RUOfmPxwSjMSEW57sEpB3OD9k8JZgE58Hk/YhFpGhbaEsoVeD999fVrsnTHnpyQWC0qOQRnBVEsMxBO+yUhj0vbmTDmAxQ4l9bONM+31Bpby2BCit+/IhWgo9ati0Bh3Kyus8SWyd2LVeQ1Kk=
Message-ID: <f2b55d220702171315xb82d37cx4f98dc9d96d51b10@mail.gmail.com>
Date: Sat, 17 Feb 2007 13:15:37 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Scott Preece" <sepreece@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Alexandre Oliva" <aoliva@redhat.com>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7b69d1470702171129x36c4352cyc5b3a4b217729bf5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <MDEHLPKNGKAHNMBLJOLKKEIPBKAC.davids@webmaster.com>
	 <orire1s39s.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	 <7b69d1470702171129x36c4352cyc5b3a4b217729bf5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Scott Preece <sepreece@gmail.com> wrote:
> Well, compilation is probably equivalent to "translation", which is
> specifically included in the Act as forming a derivative work.

Nix.  "Translation" is something that humans do.  What's governed by
copyright is the creative expression contained in a work, and it makes
no difference whether it's source code or object code, RTL or silicon,
PDF or parchment.  There's a requirement of tangible fixation for
registration purposes, so you can't claim copyright on a story that's
in your head which you haven't written down.  But what's copyrightable
about a computer program is neither the "ideas and methods of
operation" nor the blob of bits (compiled or not); it's the
idiosyncrasies, the human touches, the things that would differ
between two equally skilled coders' ways of putting those ideas into
language.

A judge doesn't care whether a C compiler will spin silk purses or
spit chunks when fed this language, except insofar as duplicating
another coder's language (by trial and error or by blatant, arrant,
heartless enslavement of poor little bytes in ROM) is obligatory in
order to build a silk-purse-spinner.  You can't claim copyright on the
only way to accomplish some engineering purpose.  Even if that purpose
is to interoperate with, or even substitute for, someone else's
software or hardware in a way that destroys its marketability or turns
its author's moral imperatives into subjunctives.  Them's the breaks,
folks; if you don't like it, write poetry instead.  (And don't use it
as a passphrase for a printer cartridge.)

(You also can't claim copyright on something that isn't your work of
authorship, so you can't just write down someone else's sermon and go
obtain copyright registration on it.  Or rather, you can, but you will
lose when you try to sue someone else for infringing it, because
you've falsified the registration.  Under the Berne Convention, you
have also not spoiled the actual author's opportunity to write it
down, register her copyright, and sue you and anyone else for
infringing it.  People who thought they licensed it legitimately from
the ostensible copyright holder may have a defense of innocent
infringement, depending on whether the author can demonstrate
negligence according to the usual tort standards in the relevant
jurisdiction.  Copyright infringement is a statutory tort, and the
only limits to contracting away the right to sue for this tort are
those provided in the copyright statute itself.  A contract not to sue
for tort is called a "license".)

Again, I recommend the Lexmark v. Static Control decision to you.  It
references the major appellate decisions in this space from the late
70's forward, mostly from the 9th and 2nd Circuits.  The full text is
available from FindLaw; the few older decisions not available from
FindLaw are easily Googled.  Or you could just mine the debian-legal
archives for the links; sadly, 80% or more of the actual citations to
case law or statute in the debian-legal archives are in my
handwriting, so you can't take that as an independent source of
information.

Cheers,
- Michael
