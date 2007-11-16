Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXKPCIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXKPCIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbXKPCIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:08:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045AbXKPCIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:08:40 -0500
Date: Thu, 15 Nov 2007 18:08:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Message-Id: <20071115180830.106d594c.akpm@linux-foundation.org>
In-Reply-To: <20071116020027.207316215@polymtl.ca>
References: <20071116015925.175012068@polymtl.ca>
	<20071116020027.207316215@polymtl.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 20:59:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

>  arch/x86/Kconfig.i386          |    1 +
>  arch/x86/Kconfig.x86_64        |    1 +

these no longer exist.
