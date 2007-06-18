Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXFRVtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXFRVtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676AbXFRVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:48:57 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26079 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932642AbXFRVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:48:55 -0400
Date: Mon, 18 Jun 2007 23:48:52 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
       GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
Message-ID: <20070618214852.GA13538@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
	GIT <git@vger.kernel.org>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de> <20070618212741.GA5938@artemis.internal.dc7.debconf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618212741.GA5938@artemis.internal.dc7.debconf.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:27:41PM +0100, Pierre Habouzit wrote:
>   FWIW there is even simpler: I maintain a backport on
> www.backports.org. Which is a semi-official service driven by Debian
> Developers.

It seems that this is only for etch (and sarge).
I run a mixed Lenny/sid machine here. It doesn't necessarily
work when I start to install things for etch. Certainly not
once testing upgrades its libc. Or?

-- 
Carlo Wood <carlo@alinoe.com>
