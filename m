Return-Path: <linux-kernel-owner+w=401wt.eu-S966057AbXDJAyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966057AbXDJAyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966056AbXDJAyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:54:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966057AbXDJAyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:54:21 -0400
Date: Mon, 9 Apr 2007 17:53:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-Id: <20070409175352.0474a3c9.akpm@linux-foundation.org>
In-Reply-To: <20070410004201.GA2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com>
	<20070404194829.1a93d8fd.dada1@cosmosbay.com>
	<20070404181050.GN2986@holomorphy.com>
	<20070409165315.4704021f.akpm@linux-foundation.org>
	<20070410004201.GA2986@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 17:42:01 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

>  My use for it is report generation in VM (and possibly other)
> testcases.

OK.  The cool kids are using taskstats for this sort of thing now, but I
note that taskstats is inexplicably missing the context-switch accounting,
and perhaps other things?

> The ack-in-concept is good enough for me to go about
> sweeping up the OS/standards compatibility, testing, and documentation
> issues in the near future prior to resubmission.

Thanks.
