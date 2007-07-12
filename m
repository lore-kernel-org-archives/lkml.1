Return-Path: <linux-kernel-owner+w=401wt.eu-S934373AbXGLOhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373AbXGLOhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbXGLOhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:37:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5472 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762056AbXGLOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:37:04 -0400
Date: Thu, 12 Jul 2007 16:37:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mark Shelby <mshelby1@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel autoconfig option?
In-Reply-To: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707121635120.25352@fbirervta.pbzchgretzou.qr>
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12 2007 10:18, Mark Shelby wrote:
>
> Would it be possible to design a program to scan your existing system
> hardware and pre-select your onboard hardware options within the
> kernel config menus?

> Am I just crazy, or wouldn't this idea mke a lot of sense? Wouldn't it
> pretty much make the kernel "idiot proof" when installing from source?

Why not just use `make allmodconfig`? If you happen to suddenly have a new
device you never had before (and I can assure you: this happens!), you
already have all modules.



	Jan
-- 
