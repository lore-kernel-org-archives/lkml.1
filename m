Return-Path: <linux-kernel-owner+w=401wt.eu-S1765004AbXJOQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765004AbXJOQlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbXJOQlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:41:06 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:9138 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256AbXJOQlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:41:03 -0400
X-ME-UUID: 20071015164102595.9144D1C0009E@mwinf2006.orange.fr
Date: Mon, 15 Oct 2007 18:36:55 +0200
From: Philippe Elie <phil.el@wanadoo.fr>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015163655.GB2884@zaniah>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015142352.GA21259@uranus.ravnborg.org> <20071015163154.GA2884@zaniah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015163154.GA2884@zaniah>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 at 18:31 +0000, Philippe Elie wrote:

> On Mon, 15 Oct 2007 at 16:23 +0000, Sam Ravnborg wrote:
> 
> > Hi Rik.
> > 
> > On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> > > The kernel newbies community often gets inquiries from CS students who
> > > need a project for their studies and would like to do something with
> > > the Linux kernel, but would also like their code to be useful to the
> > > community afterwards.
> > > 
> 
> ... 
> 
> > Increase speed for a build with no updates
> > ==========================================
> > On a resonably fast machine with a decent config it takes
> > roughly 10 seconds to do a make where nothing is updated.
> > Generating one single Makefile is assumed to speed up things
> > and will in addition allow a simpler syntax as what is used today
> > for some of the uglier constructs.
> > 
> > Contact: Sam Ravnborg <sam@ravnborg.org>
> > Difficulty: 5
> > Language: Perl or C
> 
> Isn't make -j 2 or more implemented by running multiple make in sub-dirs ?
> Parallel make is more and more used even on cheap hardware.

Errm, I misread what you said, it can be a single Makefile in each sub-dirs

> 
> -- 
> Phe
> 

