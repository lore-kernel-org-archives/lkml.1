Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbZBETsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbZBETsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763466AbZBETqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:46:22 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:53327 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763464AbZBETqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:46:20 -0500
Date: Thu, 5 Feb 2009 20:48:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing unistd_no.h and unistd_mm.h export on m68k
Message-ID: <20090205194808.GA2617@uranus.ravnborg.org>
References: <20090204181453.GE26064@csclub.uwaterloo.ca> <20090204183142.GF26064@csclub.uwaterloo.ca> <20090204184659.GG26064@csclub.uwaterloo.ca> <20090205055337.GA30333@uranus.ravnborg.org> <20090205155104.GM26064@csclub.uwaterloo.ca> <20090205155452.GN26064@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205155452.GN26064@csclub.uwaterloo.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 10:54:52AM -0500, Lennart Sorensen wrote:
> On Thu, Feb 05, 2009 at 10:51:04AM -0500, Lennart Sorensen wrote:
> 
> Oops, I forgot to do one of the requested fixes to the patch.
> 
> Here is a better one.

This looks much better.
I know patches are floating around that unify unistd.h and maybe
a few more files, so it needs to be adapted to this when applied.
But otherwise it has by:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
