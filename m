Return-Path: <linux-kernel-owner+w=401wt.eu-S936276AbYEBVCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936276AbYEBVCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYEBVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:01:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43810 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbYEBVB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:01:57 -0400
Date: Fri, 2 May 2008 23:01:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: kconfig frontend updates
Message-ID: <20080502210115.GA6666@uranus.ravnborg.org>
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
> 
> Patches follows to lkml + kbuild lists

git added a bad email address in cc:
Just ignore the error or edit away the
"sam@uranus.ravnborg.org" address.

git config is fixed so it should not happen again.

	Sam
