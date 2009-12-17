Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbZLQHrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbZLQHrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764057AbZLQHrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:47:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54332 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZLQHrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:47:09 -0500
Date: Thu, 17 Dec 2009 16:47:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH 5/5] sh: dmaengine support for sh7724
Message-ID: <20091217074700.GA19805@linux-sh.org>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange> <Pine.LNX.4.64.0912041942330.3981@axis700.grange> <e9c3a7c20912071702h1aea2026kff22db99a221f6c4@mail.gmail.com> <20091208071302.GA23814@linux-sh.org> <29ab51dc0912161914w6967c9d1l79df27d670f01b6a@mail.gmail.com> <Pine.LNX.4.64.0912170841010.5991@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912170841010.5991@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:42:39AM +0100, Guennadi Liakhovetski wrote:
> On Thu, 17 Dec 2009, Nobuhiro Iwamatsu wrote:
> > This patch can not apply Paul's git/HEAD too.
> > I updated patch.
> > 
> > Acked-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> 
> Same comment applies as to the other my patch. Paul, I think, you 
> indicated, that you've already merged my patch, or at least, that you have 
> no problem merging it. Please, do use my original version and not this 
> one.
> 
I applied it by hand, so your authorship was retained, and I fixed up the
whitespace damage by hand (it looks like it was just line wrapping from
the mailer, which I deal with often enough that I no longer particularly
care for trivial patches). For the non-trivial patches, reposting those
without whitespace damage would be preferable.
