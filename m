Return-Path: <linux-kernel-owner+w=401wt.eu-S934519AbXJQUgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbXJQUgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXJQUgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:36:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757655AbXJQUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:36:31 -0400
Date: Wed, 17 Oct 2007 13:35:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: rjw@sisk.pl, cebbert@redhat.com, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, torvalds@linux-foundation.org,
       nigel@nigel.suspend2.net, pavel@ucw.cz
Subject: Re: pm_trace displays the wrong time from the RTC
Message-Id: <20071017133549.046df71d.akpm@linux-foundation.org>
In-Reply-To: <20071017194840.GA14530@redhat.com>
References: <46AFA78A.9010904@redhat.com>
	<200708011747.37932.rjw@sisk.pl>
	<46B0CDB3.8060505@redhat.com>
	<200708012304.35105.rjw@sisk.pl>
	<20071017194840.GA14530@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 15:48:40 -0400
Dave Jones <davej@redhat.com> wrote:

> The patch below seems to have got dropped on the floor.
> We've had it in Fedora since it was posted, and it does the
> right thing, so I'm happy to give this an
> 
> ACKed-by: Dave Jones <davej@redhat.com>
> 
> if it helps it into upstream.

I have it queued for 2.6.24, but the entire PM patch series is presently
twiddling thumbs awaiting an acpi merge.
