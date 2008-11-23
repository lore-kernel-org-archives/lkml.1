Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbYKWXDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbYKWXDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYKWXC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:02:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53042 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818AbYKWXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:02:56 -0500
Date: Sun, 23 Nov 2008 23:03:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: weigelt@metux.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: scanner interface proposal was: [TALPA] Intro to a linux
 interface for on access scanning (fwd)
Message-ID: <20081123230306.48bc0274@lxorguk.ukuu.org.uk>
In-Reply-To: <20081123223753.GA16424@nibiru.local>
References: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm>
	<20081123223753.GA16424@nibiru.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fine. Why not just putting this into a userland filesystem ?

1. Performance
2. Networked file systems
3. Ioctls

and probably a few others in the thread too.

Alan
