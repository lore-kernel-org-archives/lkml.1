Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXFRWEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXFRWEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbXFRWD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:03:58 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:44344 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761431AbXFRWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:03:57 -0400
Date: Tue, 19 Jun 2007 00:03:56 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Carlo Wood <carlo@alinoe.com>, LKML <linux-kernel@vger.kernel.org>,
       GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
Message-ID: <20070618220356.GI16393@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Carlo Wood <carlo@alinoe.com>, LKML <linux-kernel@vger.kernel.org>,
	GIT <git@vger.kernel.org>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de> <20070618212741.GA5938@artemis.internal.dc7.debconf.org> <20070618214852.GA13538@alinoe.com> <20070618215610.GG16393@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618215610.GG16393@cip.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Thomas Glanzmann <thomas@glanzmann.de> [070618 23:56]:
> > It seems that this is only for etch (and sarge).  I run a mixed
> > Lenny/sid machine here. It doesn't necessarily work when I start to
> > install things for etch. Certainly not once testing upgrades its libc.
> > Or?

> true.

I guess not so true. Because debian had always compatibility libs. So I
guess when they bump the libc revision on sid, they provide a compat
library at the same time so that you're able to run the old binaries.
But don't nail me down on this one. But for the mean time you should be
good with the packages I provided in the previous e-mail for sure.

        Thomas
