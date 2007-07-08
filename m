Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbXGHJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbXGHJ50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXGHJ5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:57:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbXGHJ5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:57:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070707211141.GO3492@stusta.de>
References: <20070707211141.GO3492@stusta.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Miles Bader <miles@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: arch/v850/kernel/time.c compile error
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Sun, 08 Jul 2007 10:56:07 +0100
Message-ID: <24225.1183888567@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> Compilation on v850 fails with the following error (since 2.6.19):

I'm surprised it hasn't been fixed yet.  However, it does require some
arch-specific work, so I'm not sure I can do all of it.

David
