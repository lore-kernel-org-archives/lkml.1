Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbYF0VTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbYF0VTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYF0VTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:19:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53429 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbYF0VTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:19:42 -0400
Date: Fri, 27 Jun 2008 23:20:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH] Fix a.out.h export to userspace with O= build.
Message-ID: <20080627212029.GB3726@uranus.ravnborg.org>
References: <20080627130236.GD18644@cs181140183.pp.htv.fi> <1214571984.10393.193.camel@pmac.infradead.org> <20080627131231.GF18644@cs181140183.pp.htv.fi> <1214573982.10393.204.camel@pmac.infradead.org> <20080627205712.GA29202@uranus.ravnborg.org> <1214600756.10393.214.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214600756.10393.214.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 10:05:56PM +0100, David Woodhouse wrote:
> On Fri, 2008-06-27 at 22:57 +0200, Sam Ravnborg wrote:
> > Hi David.
> > 
> > Will you carry this patch in your tree or do you
> > want me to add it to kbuild-next.git?
> 
> I was hoping Linus would apply it, since we could consider it a
> regression.

Tested and it works.

I have added it to kbuild-fixes.git and sent Linus a pull
request.


	Sam
