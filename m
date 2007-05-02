Return-Path: <linux-kernel-owner+w=401wt.eu-S1766850AbXEBTsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766850AbXEBTsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766842AbXEBTsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:48:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766847AbXEBTsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:48:01 -0400
Date: Wed, 2 May 2007 12:47:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/21] Char: cyclades, use IS_CYC_Z macro
Message-Id: <20070502124751.3622ca49.akpm@linux-foundation.org>
In-Reply-To: <4af2d03a0705020857g9af0de1v4f65db7f3b18d19a@mail.gmail.com>
References: <1726067771982725064@wsc.cz>
	<4af2d03a0705020857g9af0de1v4f65db7f3b18d19a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 17:57:56 +0200
"Jiri Slaby" <jirislaby@gmail.com> wrote:

> On 4/29/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > cyclades, use IS_CYC_Z macro
> >
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> >
> > ---
> > commit 167ae9073fef562913c9d68d32da883da5444fbc
> > tree 5d5795a789e6ce98a5a1226cf88e2b98b1d9a12a
> > parent b462f2fd89bff92e55be6a5317a3be0ad6a93ad8
> > author Jiri Slaby <jirislaby@gmail.com> Tue, 24 Apr 2007 21:40:00 +0200
> > committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:14:54 +0200
> >
> >  drivers/char/cyclades.c |   17 ++++++-----------
> >  1 files changed, 6 insertions(+), 11 deletions(-)
> 
> Andrew, did this patchset reach you, please?

yep.

> 01-cyclades-use-is-cyc-z-macro.patch
> 02-cyclades-switch-to-pci-probing.patch
> 03-cyclades-depends-on-pci-or-isa.patch
> 04-cyclades-unexport-struct-cyclades-card.patch
> 05-cyclades-remove-useless-fileds-from-cyclades-card.patch
> 06-cyclades-irq-is-int.patch
> 07-cyclades-printk-cleanups.patch
> 08-cyclades-mark-cyy-init-card-as---devinit-not---init.patch
> 09-cyclades-simplify-variables-initialization.patch
> 10-cyclades-get-rid-of-phys-addresses.patch
> 11-cyclades-make-info-card-a-pointer.patch
> 12-cyclades-remove-sleep-on.patch
> 13-cyclades-fix-blockmove.patch
> 14-cyclades-timers-cleanup.patch
> 15-cyclades-remove-unused-timestamps.patch
> 16-cyclades-remove-locking-macros.patch
> 17-cyclades-conditions-cleanup.patch
> 18-cyclades-fix-tty-device-unregister.patch
> 19-cyclades-dynamic-ports.patch
> 20-cyclades-probe-cleanup.patch
> 21-cyclades-copyright-and-version-changes.patch
> 

I'm not merging new work like this at present: once we get 2.6.22-rc1
merged up I can start looking at new material.

