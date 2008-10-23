Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYJWB4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYJWB4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYJWB4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:56:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbYJWB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:56:40 -0400
Date: Wed, 22 Oct 2008 18:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] n-tty-fix-buffer-full-gridlock
Message-Id: <20081022185618.9c37d07d.akpm@linux-foundation.org>
In-Reply-To: <48FFD52E.70409@skyrush.com>
References: <48F2E450.1070508@skyrush.com>
	<20081022103259.2d04729a@lxorguk.ukuu.org.uk>
	<48FFD52E.70409@skyrush.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 19:36:46 -0600 Joe Peterson <joe@skyrush.com> wrote:

> Subject: [PATCH] n-tty-fix-buffer-full-gridlock

Can we stop doing this please?  Documentation/SubmittingPatches section
15 has help.

