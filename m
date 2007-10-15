Return-Path: <linux-kernel-owner+w=401wt.eu-S1764705AbXJOQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764705AbXJOQyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbXJOQyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:54:08 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:9964 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758986AbXJOQyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:54:07 -0400
X-ME-UUID: 20071015165405141.036F91C00099@mwinf2128.orange.fr
Subject: Re: WANTED: kernel projects for CS students
From: Xavier Bestel <xavier.bestel@free.fr>
To: Philippe Elie <phil.el@wanadoo.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>, Rik van Riel <riel@surriel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071015163655.GB2884@zaniah>
References: <20071014190128.6e3cdb44@bree.surriel.com>
	 <20071015142352.GA21259@uranus.ravnborg.org> <20071015163154.GA2884@zaniah>
	 <20071015163655.GB2884@zaniah>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 18:53:57 +0200
Message-Id: <1192467237.10277.33.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 18:36 +0200, Philippe Elie wrote:
> > > Increase speed for a build with no updates
> > > ==========================================
> > > On a resonably fast machine with a decent config it takes
> > > roughly 10 seconds to do a make where nothing is updated.
> > > Generating one single Makefile is assumed to speed up things
> > > and will in addition allow a simpler syntax as what is used today
> > > for some of the uglier constructs.
> > > 
> > > Contact: Sam Ravnborg <sam@ravnborg.org>
> > > Difficulty: 5
> > > Language: Perl or C
> > 
> > Isn't make -j 2 or more implemented by running multiple make in sub-dirs ?
> > Parallel make is more and more used even on cheap hardware.
> 
> Errm, I misread what you said, it can be a single Makefile in each sub-dirs

make -j works fine with an unique Makefile, if that's the question.

	Xav


