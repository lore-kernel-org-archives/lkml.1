Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXKLV4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXKLV4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXKLV4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:56:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbXKLV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:56:00 -0500
Date: Mon, 12 Nov 2007 13:55:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
Message-Id: <20071112135516.7ed4379b.akpm@linux-foundation.org>
In-Reply-To: <200711122201.45269.ak@suse.de>
References: <20071112181747.GE7296@cvg>
	<200711122201.45269.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007 22:01:45 +0100 Andi Kleen <ak@suse.de> wrote:

> On Monday 12 November 2007 19:17:47 Cyrill Gorcunov wrote:
> > This patch does remove trailing spaces from
> > source files.
> 
> That will just cause a zillion patches to not apply anymore

`patch -l'

> with exactly 0 benefit.

s/0/very small/
