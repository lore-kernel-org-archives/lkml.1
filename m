Return-Path: <linux-kernel-owner+w=401wt.eu-S964953AbXBOHRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbXBOHRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964954AbXBOHRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:17:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37578 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964953AbXBOHRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:17:22 -0500
Date: Wed, 14 Feb 2007 23:16:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
Message-Id: <20070214231635.091c7169.akpm@linux-foundation.org>
In-Reply-To: <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
	<1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007 15:03:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Linux Kernel Markers, non optimized architectures
> 
> This patch also includes marker code for non optimized architectures.

I think once we've done this we can nuke
CONFIG_MARKERS_ENABLE_OPTIMIZATION?  (Please, let it be true).

