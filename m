Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYGGQmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYGGQmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYGGQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:42:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYGGQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:42:43 -0400
Date: Mon, 7 Jul 2008 18:42:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: webmaster@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: git pull through http / git
In-Reply-To: <48724130.5050501@atmel.com>
Message-ID: <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>
References: <48724130.5050501@atmel.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-07-07 18:15, Nicolas Ferre wrote:

> Hi,
>
> I see differences when I use git to a git.kernel.org between the one I fetch
> using http protocol and the one shown through the gitweb interface.
>
> I cloned (or git remote add) the mmc tree and my config shows this url :
> url = http://www.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git
>
> but I see updates in :
> http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=summary
> I cannot get.

I don't think many care about http downloading, just because it is 
available as such.
git:// and rsync:// are available though and should be usable even 
without the http info that needs to be constantly refreshed when one 
wants to use http....

