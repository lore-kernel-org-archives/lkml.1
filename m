Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXFUGLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXFUGLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXFUGLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:11:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXFUGLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:11:12 -0400
To: david@lang.hm
Cc: Andrew McKay <amckay@iders.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615012623.GA25189@elte.hu>
	<20070615101007.0cbfd078@the-village.bc.nu>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4679557C.5080907@iders.ca>
	<20070620175627.319a6c55@the-village.bc.nu>
	<46797C52.4020907@iders.ca>
	<orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
	<ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 03:10:05 -0300
In-Reply-To: <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 22\:30\:35 -0700 \(PDT\)")
Message-ID: <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, david@lang.hm wrote:

> how exactly can they prevent a system that's been tampered with from
> accessing their network?

By denying access to their servers?  By not granting whatever is
needed to initiate network sessions?

And note, "it's been tampered with" is not necessarily enough of a
reason to cut someone off, it has to meet these requirements:

>   when the modification itself materially and adversely affects the
>   operation of the network or violates the rules and protocols for
>   communication across the network.

> (something even you say they have a right to do)

as long as this right is not used by the software distributor to
impose restrictions on the user's ability to adapt the software to
their own needs.  The GPLv3 paragraph above makes a fair concession in
this regard, don't you agree?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
