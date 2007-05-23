Return-Path: <linux-kernel-owner+w=401wt.eu-S934840AbXEWPPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840AbXEWPPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761624AbXEWPOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:14:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44160 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761250AbXEWPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:14:48 -0400
Date: Wed, 23 May 2007 08:12:15 -0700
From: Greg KH <greg@kroah.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [stable] [patch 00/69] -stable review
Message-ID: <20070523151215.GA26046@kroah.com>
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521222004.GT6291@stusta.de> <46521BFD.7040703@redhat.com> <8E8F647D7835334B985D069AE964A4F7028FE807@ECQCMTLMAIL1.quebec.int.ec.gc.ca> <20070523033651.GC26416@kroah.com> <8E8F647D7835334B985D069AE964A4F7033AB60D@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E8F647D7835334B985D069AE964A4F7033AB60D@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 07:02:29AM -0400, Fortier,Vincent [Montreal] wrote:
> > -----Message d'origine-----
> > De : Greg KH [mailto:greg@kroah.com] 
> > Envoy? : 22 mai 2007 23:37
> > ? : Fortier,Vincent [Montreal]
> > 
> > On Tue, May 22, 2007 at 09:28:34PM -0400, Fortier,Vincent 
> > [Montreal] wrote:
> > > > -----Message d'origine-----
> > > > De : linux-kernel-owner@vger.kernel.org
> > > > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Chuck 
> > > > Ebbert Envoy? : 21 mai 2007 18:24
> > > > 
> > > > Adrian Bunk wrote:
> > > > > On Mon, May 21, 2007 at 12:31:48PM -0700, Andrew Morton wrote:
> > > > >> On Mon, 21 May 2007 12:16:12 -0700 Chris Wright 
> > > > >> <chrisw@sous-sol.org> wrote:
> > > > >>
> > > > >>> This is the start of the stable review cycle for the 2.6.21.2 release.
> > > > >> Gee a lot of these are fixing recently-added regressions :( ...
> > > > > 
> > > > > If only it would fix all of them...
> > > > > 
> > > > > Michal's list [1] currently contains 51 different regressions in
> > > > > 2.6.21 compared to 2.6.20 (12 of them were already reported before
> > > > > 2.6.21 was released).
> > > > 
> > > > Yeah, 2.6.21 seems awfully buggy, and patches to fix many of the 
> > > > bugs haven't appeared.
> > > > 
> > > > Another 2.6.20 update seems to be in order...
> > > 
> > > Hi,
> > > 
> > > If there is a new stable 2.6.20 / 2.6.21, would it be 
> > possible that they both contain also this patch to keep the 
> > same behaviour between 2.6.20 -> 2.6.22 kernels regarding 
> > paravirt_ops GPL export?
> > > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=com
> > > mit;h=21564fd2a3deb48200b595332f9ed4c9f311f2a7
> > 
> > Why?  Is there an in-kernel use for that export?
> 
> I sincerely dont know... Although:

Then I'd prefer to not make this change to the -stable tree :)

thanks,

greg k-h
