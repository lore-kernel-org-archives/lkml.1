Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYBRKqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYBRKqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbYBRKqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:46:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755917AbYBRKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:46:33 -0500
Date: Mon, 18 Feb 2008 10:37:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [linux-kernel] Re: [PATCH 1/3] x86: fix init_8259A() to not use
 outb_pic
Message-ID: <20080218103726.1f4934d2@core>
In-Reply-To: <47B90417.2010406@reed.com>
References: <6gr00g$g7cm8h@smtp01.lnh.mail.rcn.net>
	<20080217222552.1af463b4@core>
	<47B8EDDA.4080801@keyaccess.nl>
	<47B90417.2010406@reed.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I left those that were previously not _p alone. I suspect they should
proeprly be _pic however.
