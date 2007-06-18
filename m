Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXFRWFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXFRWFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764552AbXFRWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:04:51 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:38961 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901AbXFRWEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:04:50 -0400
Date: Tue, 19 Jun 2007 00:04:41 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>, GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
Message-ID: <20070618220441.GC13538@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	LKML <linux-kernel@vger.kernel.org>, GIT <git@vger.kernel.org>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de> <20070618212741.GA5938@artemis.internal.dc7.debconf.org> <20070618214852.GA13538@alinoe.com> <20070618215610.GG16393@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618215610.GG16393@cip.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:56:10PM +0200, Thomas Glanzmann wrote:
> true. But when you run sid you get a newer version of git automatically.
> Sooner or later. And you can always build it yourself. It's a pain in
> the ass until you have all build dependencies installed and all the
> tests pass.

Oh, I already build it before my previous post :p

I just did:

sudo apt-get install libz-dev asciidoc xmlto libexpat1-dev subversion unzip tcl8.4 libsvn-perl libcurl3-dev

after having a peek at git-core_1.5.2.1-1.dsc, and then it did build
just fine immediately.

-- 
Carlo Wood <carlo@alinoe.com>
