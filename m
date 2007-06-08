Return-Path: <linux-kernel-owner+w=401wt.eu-S936685AbXFHOvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936685AbXFHOvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXFHOuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:50:52 -0400
Received: from raven.upol.cz ([158.194.120.4]:40472 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbXFHOuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:50:51 -0400
Date: Fri, 8 Jun 2007 17:02:15 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] scripts: clean-whitespace.sh
Message-ID: <20070608150215.GY7266@flower.upol.cz>
References: <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr> <20070607230657.GV7266@flower.upol.cz> <4668929C.7040209@zytor.com> <E1HwY9K-0008Jz-CG@flower> <20070607234459.e4dffd65.akpm@linux-foundation.org> <20070608142849.GA23642@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608142849.GA23642@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 04:28:49PM +0200, Sam Ravnborg wrote:
> On Thu, Jun 07, 2007 at 11:44:59PM -0700, Andrew Morton wrote:
> > 
> > Then again, it's a better strategy than trying to read the code ;)
> > 
> > Please, tell us what it does, so that we can decide whether we want it in
> > Linux.
> 
> It does the same as cleanfile.pl.
> I have seen no reason to replace cleanfile.pl with this version.

It does better whitespace cleanup, than

scripts/{cleanfile *and* cleanpatch}

togather with more user, operating system kernel-friendly approach.
Please, test it on proposed testcase - ipv6.h, and you will see, what i'm
talking about. Patch description + script name is all one must to know to
start use it *safely*.

> Linecount is down but so is maintainability / extendability.

Really? If you think so...

For those, who have (X)emacs on board, i recommend "develock.el" as
good damage-showing tool.

Sorry, Andrew, for garbage in you patch subject filters :)
____
