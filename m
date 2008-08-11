Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYHKWCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYHKWCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYHKWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:02:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59118 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846AbYHKWC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:02:28 -0400
Date: Mon, 11 Aug 2008 22:45:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: daw-news@cs.berkeley.edu (David Wagner)
Cc: daw@cs.berkeley.edu, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080811224516.57194a54@lxorguk.ukuu.org.uk>
In-Reply-To: <g7qccj$6m0$1@taverner.cs.berkeley.edu>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi>
	<200808111645.48177.mdontu@bitdefender.com>
	<20080811065608.44687f65@infradead.org>
	<48A0649B.4010706@sun.com>
	<g7qccj$6m0$1@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 21:53:23 +0000 (UTC)
daw@cs.berkeley.edu (David Wagner) wrote:

> David Collier-Brown writes:
> >Arjan van de Ven wrote:
> >> we do still appreciate your description, since I don't think there's a
> >> clear "here's what we really try to protect against" statement yet.
> >
> >  Perhaps I could try: the AV folks are trying to prevent the
> >execution of either modified normal binaries/files or 
> >specifically exploit binaries/files, by machines for which the 
> >files are executable or interpretable.
> 
> 1. We already know how to prevent/detect modifications to
> normal binaries.  See Tripwire etc.  As far as I know, no new
> kernel technology is needed.

Tripwire is incredibly ineffecient and ineffectual because we don't have
a scalable 'file was modified' notifier

Alan
