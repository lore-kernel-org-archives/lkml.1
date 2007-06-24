Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbXFXTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbXFXTjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXFXTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:39:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbXFXTjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:39:23 -0400
Date: Sun, 24 Jun 2007 12:39:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Update the alignment for 4K stacks.
Message-Id: <20070624123906.5e1c4b2a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706241518590.24337@localhost.localdomain>
References: <Pine.LNX.4.64.0706241518590.24337@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 15:21:37 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

>  arch/i386/kernel/irq.c |    8 ++------
>  arch/sh/kernel/irq.c   |    8 ++------

These two files are maintained by different developers who run
separate development trees.  Please do not try to alter them
both in the same patch.
