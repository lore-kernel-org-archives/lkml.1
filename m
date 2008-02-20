Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbYBTJwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbYBTJwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYBTJwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:52:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393AbYBTJwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:52:41 -0500
Date: Wed, 20 Feb 2008 01:51:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] AMD opteron mm config numa etc
Message-Id: <20080220015115.a5989384.akpm@linux-foundation.org>
In-Reply-To: <20080220063752.GD7493@elte.hu>
References: <200802190319.28699.yinghai.lu@sun.com>
	<20080219112322.GD7204@elte.hu>
	<20080219175339.GB8344@kroah.com>
	<20080220063752.GD7493@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 07:37:52 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Note: Andrew might get grumpy when 
> your PCI tree starts changing nearby places in arch/x86/pci again and it 
> clashes with these changes in x86.git

s/Andrew/Stephen/I hope/;)/

Hopefully we can soon start feeding these more problematic trees into linux-next
and yes, Stephen will need some more thought/support from his upstreams to make
that viable.

