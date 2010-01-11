Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983Ab0AKVoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0AKVoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179Ab0AKVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:44:09 -0500
Received: from coloquinte.cristau.org ([91.121.16.100]:44843 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0AKVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:44:07 -0500
Date: Mon, 11 Jan 2010 21:43:55 +0000
From: Julien Cristau <jcristau@debian.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
Message-ID: <20100111214355.GA11456@radis.liafa.jussieu.fr>
References: <201001090045.33784.rjw@sisk.pl>
 <20100111083825.4c2bb7b3@jbarnes-piketon>
 <21d7e9971001111212h1ded5292l94d514c6f5a47cd4@mail.gmail.com>
 <201001112204.36724.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001112204.36724.rjw@sisk.pl>
X-Operating-System: Linux 2.6.32-trunk-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 22:04:36 +0100, Rafael J. Wysocki wrote:

> Hmm, are you trying to say radeon is better at that?
> 
> My experience is quite the opposite to be honest.
> 
radeon kms is in staging, doesn't pretend to be stable and force all
users to the experimental paths.  So yes, I would say radeon is better
at that.

Cheers,
Julien
