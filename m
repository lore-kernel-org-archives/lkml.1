Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbXEOQms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbXEOQms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXEOQml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:42:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33921 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758095AbXEOQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:42:40 -0400
Date: Tue, 15 May 2007 17:46:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [patch i2o 6/6] i2o debug output cleanup
Message-ID: <20070515174625.72c61c8c@the-village.bc.nu>
In-Reply-To: <4649AC10.60903@sw.ru>
References: <4649AA6C.2080808@sw.ru>
	<4649AC10.60903@sw.ru>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:48:16 +0400
Vasily Averin <vvs@sw.ru> wrote:

> fixed output of i2o debug messages, extra KERN_ are removed
> 


Otherwise looks good. ACK apart from the interesting goto targets and
the /proc handling.
