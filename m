Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXCYWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXCYWjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXCYWjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:39:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33470 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXCYWjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:39:48 -0400
Date: Sun, 25 Mar 2007 14:39:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] INPUT: Delete unused source file drivers/input/power.c.
Message-Id: <20070325143938.22c3b26d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703251624330.31635@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703251624330.31635@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 16:28:39 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> Delete the never-compiled source file drivers/input/power.c, and
> remove its entry from the corresponding Makefile, as there is no
> Kconfig file that refers to the config option INPUT_POWER.

Please cc the maintainer when he's this easy to find ;)

There are significant-looking patches against input.c in the git-input
tree - if it's presently dead I suspect that it'll be coming back to
life soon.
