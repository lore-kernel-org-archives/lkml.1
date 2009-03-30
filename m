Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZC3VW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZC3VW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZC3VWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:22:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbZC3VWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:22:19 -0400
Date: Mon, 30 Mar 2009 14:18:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: roel.kluin@gmail.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hvc_console: prevent wrapping in hvc_console_print()
Message-Id: <20090330141852.59baaeda.akpm@linux-foundation.org>
In-Reply-To: <20090330205553.GA19278@yoda.jdub.homelinux.org>
References: <49BF956B.9030109@gmail.com>
	<20090330133531.f5d99c09.akpm@linux-foundation.org>
	<20090330205553.GA19278@yoda.jdub.homelinux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 16:55:53 -0400
Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:

> On Mon, Mar 30, 2009 at 01:35:31PM -0700, Andrew Morton wrote:
> >Guys, could we have a MAINTAINERS entry for this driver please?
> 
> To my knowledge, there isn't one.  Would be Ben now by default I
> guess.  The previous developers have disclaimed ownership for a
> while from what I remember.
> 

A MAINAINERS record doesn't have to identify an individual.  It can at
least point people at the appropriate mailing list(s).

