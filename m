Return-Path: <linux-kernel-owner+w=401wt.eu-S934492AbZIDXR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbZIDXR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 19:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934474AbZIDXR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 19:17:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934478AbZIDXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 19:17:26 -0400
Date: Fri, 4 Sep 2009 16:17:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Message-Id: <20090904161724.81016db0.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0909040556j58f5a5fds5a0c2712d05e3cb3@mail.gmail.com>
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
	<a8e1da0909040556j58f5a5fds5a0c2712d05e3cb3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 20:56:41 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> Hi, andrew
> 
> Building failed with lzo kernel config:
> 
> In file included from arch/x86/boot/compressed/misc.c:166:
> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:95: error:
> static declaration of 'unlzo' follows non-static declaration
> include/linux/decompress/unlzo.h:9: error: previous declaration of
> 'unlzo' was here

OK, thanks.  I dropped the LZO patches.  The versions I had were out of
date anyway.

