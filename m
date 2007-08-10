Return-Path: <linux-kernel-owner+w=401wt.eu-S1764992AbXHJI1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764992AbXHJI1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXHJI13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:27:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:54979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXHJI11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:27:27 -0400
Date: Fri, 10 Aug 2007 10:27:26 +0200
From: Olaf Hering <olh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Cc: Michael Matz <matz@suse.de>
Subject: Re: [PATCH] remove strict ansi check from __u64 in asm/types.h
Message-ID: <20070810082726.GA26232@suse.de>
References: <20070806172331.GA8102@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070806172331.GA8102@suse.de>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, Olaf Hering wrote:

> Remove the __STRICT_ANSI__ check from the __u64/__s64 declaration on
> 32bit targets.

> (Currently) untested patch below.

We tested this now, and it did not cause failures.

Andrew, will you pick this up?
