Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXKVXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXKVXey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXKVXer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 18:34:47 -0500
Received: from www.tglx.de ([62.245.132.106]:59976 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXKVXeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 18:34:46 -0500
Date: Fri, 23 Nov 2007 00:34:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Use CR0 defines.
In-Reply-To: <20071120002459.GA11042@redhat.com>
Message-ID: <alpine.LFD.0.9999.0711230033480.25057@localhost.localdomain>
References: <20071120002459.GA11042@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Dave Jones wrote:

> We have definitions of the CR0 bits in processor-flags.h
> Use them instead of hardcoded values in various places.

Applied, thanks

	 tglx
