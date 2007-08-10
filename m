Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbXHJIfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbXHJIfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXHJIfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:35:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758027AbXHJIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:35:35 -0400
Date: Fri, 10 Aug 2007 01:34:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olh@suse.de>
Cc: linux-kernel@vger.kernel.org, Michael Matz <matz@suse.de>
Subject: Re: [PATCH] remove strict ansi check from __u64 in asm/types.h
Message-Id: <20070810013456.109ab017.akpm@linux-foundation.org>
In-Reply-To: <20070810082726.GA26232@suse.de>
References: <20070806172331.GA8102@suse.de>
	<20070810082726.GA26232@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 10:27:26 +0200 Olaf Hering <olh@suse.de> wrote:

> On Mon, Aug 06, Olaf Hering wrote:
> 
> > Remove the __STRICT_ANSI__ check from the __u64/__s64 declaration on
> > 32bit targets.
> 
> > (Currently) untested patch below.
> 
> We tested this now, and it did not cause failures.
> 
> Andrew, will you pick this up?

can take a look, sure.  Can you send a version with a less scruffy-looking
changelog please?
