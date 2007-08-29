Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbXH2V4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbXH2V4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbXH2V4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:56:08 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54966 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbXH2V4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:56:05 -0400
Date: Wed, 29 Aug 2007 17:54:36 -0400
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-wireless@vger.kernel.org, Michael Buesch <mbuesch@freenet.de>,
       Stefano Brivio <st3@riseup.net>,
       Andrew Clayton <andrew@digital-domain.net>, Shish <shish@shishnet.org>,
       Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Karl Meyer <adhocrocker@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       Francois Romieu <romieu@fr.zoreil.com>, nfs@lists.sourceforge.net,
       Netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Martin Langer <martin-langer@gmx.de>,
       Andreas Jaggi <andreas.jaggi@waterwave.ch>,
       Danny van Dyk <kugelfang@gentoo.org>
Subject: Re: [NFS] [3/4] 2.6.23-rc4: known regressions
Message-ID: <20070829215436.GB9731@fieldses.org>
References: <46D58CC6.4020605@googlemail.com> <46D5906B.1030701@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D5906B.1030701@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 05:27:39PM +0200, Michal Piotrowski wrote:
> FS
> 
> Subject         : [NFSD OOPS] 2.6.23-rc1-git10
> References      : http://lkml.org/lkml/2007/8/2/462
> Last known good : ?
> Submitter       : Andrew Clayton <andrew@digital-domain.net>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

This is a bug, but (alas) appears to be a preexisting bug, so may not
belong on this list.--b.
