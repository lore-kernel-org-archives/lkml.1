Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYEDS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYEDS5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYEDS5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:57:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35780 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYEDS5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:57:05 -0400
Date: Sun, 4 May 2008 20:57:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: kconfig frontend updates
Message-ID: <20080504185737.GA23063@uranus.ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502204729.GA6534@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:47:29PM +0200, Sam Ravnborg wrote:
> The following patchset implments the following:
> 
> o Inputfiles to all*config can be specified with K=
> o less chatty oldconfig mode
> o Drop useless warnings
> 
> This is work-in-progress aimed for next mergewindow.
> Posted here mainly to get some feedback and a
> bit of review.

New set of patches (2) will follow.
The warning "trying to assign nonexistent symbol" remains for now.
I do not want to mix the two things.

The patches are also pushed to kbuild.git so they
will appear in -next and -mm.
Let's see how many scripts will break due to this ;-)

Comments /testing welcome.

	Sam
