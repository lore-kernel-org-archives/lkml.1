Return-Path: <linux-kernel-owner+w=401wt.eu-S933818AbYDYTKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818AbYDYTKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765365AbYDYS5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:57:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42744 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912AbYDYS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:57:13 -0400
Date: Fri, 25 Apr 2008 20:57:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Richard Hacker <lerichi@gmx.net>
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/002] scripts/mod/modpost.c: New option -E to load extra symbols
Message-ID: <20080425185745.GB10902@uranus.ravnborg.org>
References: <200802280940.53020.lerichi@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802280940.53020.lerichi@gmx.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 09:40:52AM +0100, Richard Hacker wrote:
> This patch adds a new command line option -E to modpost, expecting a symbol
> file as an argument which is read prior to symbol processing. -E can be 
> supplied multiple times for as many files as is needed.
> 
> Signed-off-by: Richard Hacker <lerichi@gmx.net>

I edited the patches slightly and renamed the
variable to KBUILD_EXTRA_SYMBOLS.
Patches has been pushed and will soon appear in mainline.

Thanks,
	Sam
