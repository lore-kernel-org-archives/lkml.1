Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbXHDQkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbXHDQkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764660AbXHDQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:40:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764648AbXHDQkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:40:22 -0400
Date: Sat, 4 Aug 2007 09:34:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       stable@kernel.org
Subject: Re: [PATCH] unexport asm/shmparam.h
Message-Id: <20070804093437.4a48d5d9.akpm@linux-foundation.org>
In-Reply-To: <20070804100743.GB15222@aepfle.de>
References: <20070714193834.GA9140@aepfle.de>
	<20070804100743.GB15222@aepfle.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 12:07:43 +0200 Olaf Hering <olaf@aepfle.de> wrote:

> On Sat, Jul 14, Olaf Hering wrote:
> 
> > SHMLBA cant possible be used in userspace, see sparc versions of that header.
> 
> Ping.

ping who?

> Anything wrong with this patch?

Not afaik.  I queued it for 2.6.24.
