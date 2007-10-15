Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbXJOQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbXJOQgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbXJOQgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:36:06 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:62309 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbXJOQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:36:04 -0400
X-ME-UUID: 20071015163602452.6E7CA1C00099@mwinf2006.orange.fr
Date: Mon, 15 Oct 2007 18:31:54 +0200
From: Philippe Elie <phil.el@wanadoo.fr>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015163154.GA2884@zaniah>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015142352.GA21259@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015142352.GA21259@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 at 16:23 +0000, Sam Ravnborg wrote:

> Hi Rik.
> 
> On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> > The kernel newbies community often gets inquiries from CS students who
> > need a project for their studies and would like to do something with
> > the Linux kernel, but would also like their code to be useful to the
> > community afterwards.
> > 

... 

> Increase speed for a build with no updates
> ==========================================
> On a resonably fast machine with a decent config it takes
> roughly 10 seconds to do a make where nothing is updated.
> Generating one single Makefile is assumed to speed up things
> and will in addition allow a simpler syntax as what is used today
> for some of the uglier constructs.
> 
> Contact: Sam Ravnborg <sam@ravnborg.org>
> Difficulty: 5
> Language: Perl or C

Isn't make -j 2 or more implemented by running multiple make in sub-dirs ?
Parallel make is more and more used even on cheap hardware.

-- 
Phe

