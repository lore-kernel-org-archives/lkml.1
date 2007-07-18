Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbXGRJ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbXGRJ4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXGRJ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:56:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbXGRJ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:56:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200707171039.58182.yinghai.lu@sun.com>
References: <200707171039.58182.yinghai.lu@sun.com> <15587.1184685298@redhat.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: add back early_serial_setup back to head file
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Wed, 18 Jul 2007 10:55:54 +0100
Message-ID: <17523.1184752554@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] serial: add back early_serial_setup back to head file
> 
> early_serial_setup is removed from serial.h, but foget to put in
> serial_8250.h
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Acked-By: David Howells <dhowells@redhat.com>
