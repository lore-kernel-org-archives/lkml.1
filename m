Return-Path: <linux-kernel-owner+w=401wt.eu-S1761116AbXJMAuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761116AbXJMAuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXJMAun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:50:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756627AbXJMAum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:50:42 -0400
Date: Fri, 12 Oct 2007 17:49:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Correct filenames in comments.
Message-Id: <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
In-Reply-To: <20071013004332.GA18760@redhat.com>
References: <20071013004332.GA18760@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 20:43:32 -0400
Dave Jones <davej@redhat.com> wrote:

> I never really understood the motivation behind putting the filename
> in a comment, but this fixes up a bunch of them that are now wrong
> post-merge.

Let's just delete them.
