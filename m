Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYGAUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYGAUJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYGAUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:09:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49086 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYGAUJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:09:03 -0400
Date: Tue, 1 Jul 2008 22:09:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux fatal: cannot describe <sha1>
Message-ID: <20080701200951.GB10677@uranus.ravnborg.org>
References: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807011817230.20393@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 06:20:17PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> Just a note that when you run git-describe, you should probably quiten it.
> 
> fatal: cannot describe 'bd7364a0fd5a4a2878fe4a224be1b142a4e6698e'
> 
> This happens when tags are not present, which can happen if Linus's tree 
> is sent upwards again, IOW:
> 
>  machine1$  git-clone torvalds/linux-2.6.git
>  machine1$  git push elsewhere master
> 
>  machine2$  git-clone elsewhere:/linux
>  machine2$  git-describe HEAD
>  fatal: cannot describe that

Hi Jan.

Any specific reason why you sent it to me?
Maybe because I do not use git describe at all?

	Sam

