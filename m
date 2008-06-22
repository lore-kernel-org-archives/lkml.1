Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYFVRZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYFVRZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYFVRZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:25:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50576 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752776AbYFVRZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:25:43 -0400
Date: Sun, 22 Jun 2008 18:07:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: (Resend of 23/70 plus reply [PATCH 00/70] tty updates proposed
 for 2.6.27)
Message-ID: <20080622180756.75a54ff4@lxorguk.ukuu.org.uk>
In-Reply-To: <20080621111936.GB27069@cs181133002.pp.htv.fi>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
	<20080621090910.GA12516@kroah.com>
	<20080621111709.7e8f7d44@lxorguk.ukuu.org.uk>
	<20080621111936.GB27069@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The USB_SERIAL_TI_FIRMWARE bits don't seem to belong here?

They seem to have gotten merged together by accident - shouldn't do any
harm and both want doing. I can take a look at splitting it if Greg
wants ?

Alan
