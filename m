Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZLQICK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZLQICK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZLQICI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:02:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:57852 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752401AbZLQICH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:02:07 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX180ygwHQDU0HgO/xjAdLiJjc9ZdkRDlIzpCIk9U0K
	UQRUfxUqIbVnkl
Date: Thu, 17 Dec 2009 09:02:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH 5/5] sh: dmaengine support for sh7724
In-Reply-To: <20091217074700.GA19805@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0912170856280.5991@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
 <Pine.LNX.4.64.0912041942330.3981@axis700.grange>
 <e9c3a7c20912071702h1aea2026kff22db99a221f6c4@mail.gmail.com>
 <20091208071302.GA23814@linux-sh.org> <29ab51dc0912161914w6967c9d1l79df27d670f01b6a@mail.gmail.com>
 <Pine.LNX.4.64.0912170841010.5991@axis700.grange> <20091217074700.GA19805@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul

On Thu, 17 Dec 2009, Paul Mundt wrote:

> On Thu, Dec 17, 2009 at 08:42:39AM +0100, Guennadi Liakhovetski wrote:
> > On Thu, 17 Dec 2009, Nobuhiro Iwamatsu wrote:
> > > This patch can not apply Paul's git/HEAD too.
> > > I updated patch.
> > > 
> > > Acked-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> > 
> > Same comment applies as to the other my patch. Paul, I think, you 
> > indicated, that you've already merged my patch, or at least, that you have 
> > no problem merging it. Please, do use my original version and not this 
> > one.
> > 
> I applied it by hand, so your authorship was retained, and I fixed up the
> whitespace damage by hand (it looks like it was just line wrapping from
> the mailer, which I deal with often enough that I no longer particularly
> care for trivial patches). For the non-trivial patches, reposting those
> without whitespace damage would be preferable.

Hm, strange, are you sure _my_ original version was white-space damaged? I 
am quite sure my mailing chain behaves, and I just double-checked my patch 
as I got it back from the list - it looks ok to me. Would be interesting 
to know what specific white-space issues you found there, you could just 
mail me those off-list, if you like.

Thanks
Guennadi
---
Guennadi Liakhovetski
