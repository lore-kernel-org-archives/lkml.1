Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZAGKVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZAGKVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZAGKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:21:32 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50312 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754681AbZAGKVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:21:31 -0500
Date: Wed, 7 Jan 2009 11:21:19 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/23] avr32: introduce asm/swab.h
Message-ID: <20090107112119.2e12d737@hskinnemoen-d830>
In-Reply-To: <1231277445.964.259.camel@brick>
References: <1231277445.964.259.camel@brick>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Looks good to me. This fixes the recent userspace breakage, right?

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
