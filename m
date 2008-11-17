Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYKQRJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYKQRJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKQRJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:09:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:42014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYKQRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:08:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=TEVs6IJotFXy7L8ShBov+e5/6CJLwWRjLa+OxV8wgcwaTxi0oz7XtKU7JQ4x6xAqg
	z+C66DWwqjr5t0T2alSmQ==
Subject: Re: [PATCH 0/3] more fixes for "timers: fix itimer/many thread
	hang"
From: Frank Mayhar <fmayhar@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, Doug Chapman <doug.chapman@hp.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081117143938.GA5352@redhat.com>
References: <20081117143938.GA5352@redhat.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 17 Nov 2008 09:08:21 -0800
Message-Id: <1226941701.23804.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 15:39 +0100, Oleg Nesterov wrote:
> Compile tested, please review.
> 
> The first one is imho 2.6.28 material, others are cleanups.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Oleg, I really want to thank you for this work.  I wanted to get to this
but I've been up to my neck in work stuff for the last couple of weeks
and for the foreseeable future so I just haven't had time.  Thanks so
much for taking it on!
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

