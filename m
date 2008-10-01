Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYJAXYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYJAXYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJAXY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:24:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbYJAXY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:24:26 -0400
Date: Wed, 1 Oct 2008 16:23:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       arjan@infradead.org, benh@kernel.crashing.org, rostedt@goodmis.org,
       jonathan@jonmasters.org, sdietrich@suse.de
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
 interrupt handlers
Message-Id: <20081001162333.e1509240.akpm@linux-foundation.org>
In-Reply-To: <20081001223213.078984344@linutronix.de>
References: <20081001223213.078984344@linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2008 23:02:08 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> This patch series implements support for threaded irq handlers for the
> generic IRQ layer.
> 
> ...
> 
> I hope to have a real converted driver (aside of the dummy module used
> for testing) ready real soon

That would be nice ;)


I'm a bit surprised to see that there is no facility for per-cpu
interrupt threads?

