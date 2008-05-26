Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYEZNz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYEZNz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYEZNzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:55:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYEZNzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:55:19 -0400
Date: Mon, 26 May 2008 10:55:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l: fix meaning of tea5767_autodetection
Message-ID: <20080526105505.06db1360@gaivota>
In-Reply-To: <20080511195219.GC19058@joi>
References: <20080511195219.GC19058@joi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin,

On Sun, 11 May 2008 21:52:23 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> 1) tea5767_autodetection should return negative values on errors
> 2) tuner_probe should check only for zero/non-zero

Thanks. However, a similar patch were already committed at my -git. I suspect
that I've already sent it also to mainstream.

Cheers,
Mauro
