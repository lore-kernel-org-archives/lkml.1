Return-Path: <linux-kernel-owner+w=401wt.eu-S1764648AbXHDKHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764648AbXHDKHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 06:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXHDKHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 06:07:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42880 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXHDKHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 06:07:40 -0400
Date: Sat, 4 Aug 2007 12:07:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Cc: stable@kernel.org
Subject: Re: [PATCH] unexport asm/shmparam.h
Message-ID: <20070804100743.GB15222@aepfle.de>
References: <20070714193834.GA9140@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070714193834.GA9140@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, Olaf Hering wrote:

> SHMLBA cant possible be used in userspace, see sparc versions of that header.

Ping.
Anything wrong with this patch?
