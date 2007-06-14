Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXFNHsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXFNHsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXFNHso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:48:44 -0400
Received: from mx10.go2.pl ([193.17.41.74]:41400 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751028AbXFNHsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:48:43 -0400
Date: Thu, 14 Jun 2007 09:56:24 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Fortier\,Vincent \[Montreal\]" <Vincent.Fortier1@EC.GC.CA>
Cc: Miguel Figueiredo <elmig@debianpt.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: call for more SD versus CFS comparisons (was: Re: Mainline plans)
Message-ID: <20070614075624.GA1450@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B01289E9@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-2007 03:54, Fortier,Vincent [Montreal] wrote:
...
> Kernels:
> CFS v16 2.6.21 FC7 build 3194
> CK2 2.6.21 FC7 build 3194
...
> CFS v16:
> ---------
> beryl interractivity way too unresponsive..
> - window decoration highlight taking around 5-10 secs to switch between windows focus
> - window movement either impossible or animation laggy enough to not being seen at all.
> - Cube rotation still possible using mouse scroll although really really really laggy
> 
> Amarok MP3 music:
> - No audio skips at all.  Playing really well!
> 
> 
> CK2 patchset:
> -------------
> Beryl interractivity almost totally unresponsive... In fact mouse movement was near-impossible to control.
> - window movement totally impossible
> - Cube rotation still possible using mouse scroll although there was no animation at all
> 
> Amarok MP3 music:
> - Same as CFS, no skips at all.  Playing really well!
...

Very nice testing! But, maybe it could be even more interesting after
adding here the "vanilla" kernel too, i.e. 2.6.21 FC7 build 3194
without CFS/CK2?

Regards,
Jarek P.
