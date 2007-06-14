Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbXFNFCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbXFNFCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXFNFBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:01:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbXFNFBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:01:54 -0400
To: Daniel Forrest <forrest@lmcg.wisc.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Adams <cmadams@hiwaay.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no>
	<fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no>
	<fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no>
	<fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no>
	<fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no>
	<20070614013214.GA1124293@hiwaay.net>
	<20070614025248.6e0f72f0@the-village.bc.nu>
	<20070613212250.A21801@yoda.lmcg.wisc.edu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 02:01:47 -0300
In-Reply-To: <20070613212250.A21801@yoda.lmcg.wisc.edu> (Daniel Forrest's message of "Wed\, 13 Jun 2007 21\:22\:50 -0500")
Message-ID: <orodjji0xw.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Daniel Forrest <forrest@lmcg.wisc.edu> wrote:

> 1.) I ship the device back to the manufacturer, they replace the ROM,
>     and ship it back to me.

> 2.) I ship the device back to the manufacturer, they load new code
>     into it, and ship it back to me.

> How do these two differ?  Or is it now just a question of the ROM
> being in a socket?  I can't see how the technicalities of how the
> hardware is constructed can change the legality of the software.

I don't see that they differ.  If the software can be replaced, the
manufacturer ought to tell you how to do it.  It doesn't have to do it
for you, it doesn't have to give you the hardware tools needed to do
it, but if you're not able to start from the source code and the
information provided by the manufacturer and get to a modified version
of the software on the device, while the manufacturer could do it,
then the manufacturer is locking you in, and therefore you're not
free.  This is a clear violation of the spirit of the license, even if
the legalese might make room for some such misbehavior.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
