Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXFUTzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXFUTzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbXFUTyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:54:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326AbXFUTyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:54:19 -0400
To: david@lang.hm
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Michael Poole <mdpoole@troilus.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm>
	<87sl8ms9z5.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm>
	<87k5tys8w5.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm>
	<87645is82q.fsf@graviton.dyn.troilus.org>
	<20070621171612.GC10008@csclub.uwaterloo.ca>
	<Pine.LNX.4.64.0706211019510.31603@asgard.lang.hm>
	<20070621174332.GD10008@csclub.uwaterloo.ca>
	<Pine.LNX.4.64.0706211046511.31603@asgard.lang.hm>
	<20070621180538.GE10008@csclub.uwaterloo.ca>
	<Pine.LNX.4.64.0706211110340.31603@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 16:54:08 -0300
In-Reply-To: <Pine.LNX.4.64.0706211110340.31603@asgard.lang.hm> (david@lang.hm's message of "Thu\, 21 Jun 2007 11\:29\:04 -0700 \(PDT\)")
Message-ID: <ortzt1jd7j.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, david@lang.hm wrote:

> On Thu, 21 Jun 2007, Lennart Sorensen wrote:

>> You can't use this code if you cooporate with anyone that requires
>> DRM systems.

> I think their earlier versions did say this.

Show me a GPLv3 draft that did it?

Start here, section 3:
http://gplv3.fsf.org/gpl-draft-2006-01-16.html

> DRM does have some legitimate uses, for example redhat installations
> not installing unsigned software is a form of DRM

Doh.  Then chmod og-r is DRM too.  And stronger DRM while at that,
since the user denied permission to read the file cannot take it back,
whereas the verification of unsigned software is just a warning, that
you can often bypass by telling the software to go ahead and install
it regardless of signatures.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
