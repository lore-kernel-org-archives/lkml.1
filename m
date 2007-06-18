Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXFRV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXFRV4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765405AbXFRV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:56:13 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:43824 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765258AbXFRV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:56:12 -0400
Date: Mon, 18 Jun 2007 23:56:10 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Carlo Wood <carlo@alinoe.com>, LKML <linux-kernel@vger.kernel.org>,
       GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
Message-ID: <20070618215610.GG16393@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Carlo Wood <carlo@alinoe.com>, LKML <linux-kernel@vger.kernel.org>,
	GIT <git@vger.kernel.org>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de> <20070618212741.GA5938@artemis.internal.dc7.debconf.org> <20070618214852.GA13538@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618214852.GA13538@alinoe.com>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> It seems that this is only for etch (and sarge).  I run a mixed
> Lenny/sid machine here. It doesn't necessarily work when I start to
> install things for etch. Certainly not once testing upgrades its libc.
> Or?

true. But when you run sid you get a newer version of git automatically.
Sooner or later. And you can always build it yourself. It's a pain in
the ass until you have all build dependencies installed and all the
tests pass. Most of them you can get by typing:

        apt-get build-dep git-core

But after that it is very straight forward.

        Thomas
