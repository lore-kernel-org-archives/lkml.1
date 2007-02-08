Return-Path: <linux-kernel-owner+w=401wt.eu-S1030560AbXBHD2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030560AbXBHD2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030640AbXBHD2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:28:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52524 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030560AbXBHD2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:28:36 -0500
Date: Wed, 7 Feb 2007 19:28:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: linux-kernel@vger.kernel.org
Subject: Re: `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
In-Reply-To: <1170897212.7070.15.camel@lade.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0702071924570.8424@woody.linux-foundation.org>
References: <1170897212.7070.15.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Feb 2007, Trond Myklebust wrote:
>
> The latest pull from the git tree spews out a torrent of the above
> warning on a recent Fedora Core 6 machine running gcc-4.1.1. config file
> is attached...

Should hopefully be fixed already in current -git

		Linus
