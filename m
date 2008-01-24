Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYAXVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYAXVXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYAXVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:23:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42739 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYAXVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:23:36 -0500
Date: Thu, 24 Jan 2008 22:23:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kconfig: show git branch name in LOCALVERSION_AUTO
Message-ID: <20080124212345.GA3944@uranus.ravnborg.org>
References: <1200916933.2906.17.camel@castor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200916933.2906.17.camel@castor.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 12:02:13PM +0000, Richard Kennedy wrote:
> config option to add the git branch name to the automatically generated
> version string.
> 
> If the current git branch name is not "master" then add the name to the
> LOCALVERSION_AUTO version string.
> The format will then be -<name>-gxxxxxxxx

PAtch does no longer apply to kbuild.git.
Please update either on top of kbuild.git or
when kbuild.git is merged and then resubmit.

Thanks,
	Sam
