Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZCKLhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZCKLhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZCKLg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:36:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZCKLgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:36:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090311003235.677690312@linutronix.de>
References: <20090311003235.677690312@linutronix.de> <20090311003204.592133594@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 03/18] mn10300: convert obsolete no_irq_type to no_irq_chip
Date: Wed, 11 Mar 2009 11:35:45 +0000
Message-ID: <18205.1236771345@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> convert the last remaining users to no_irq_chip
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David Howells <dhowells@redhat.com>
