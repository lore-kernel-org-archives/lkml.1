Return-Path: <linux-kernel-owner+w=401wt.eu-S1767151AbXEBWqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767151AbXEBWqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767155AbXEBWqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:46:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:37517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767151AbXEBWqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:46:16 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: Why ssse3?
Date: Thu, 3 May 2007 00:46:07 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <46391392.4070706@redhat.com>
In-Reply-To: <46391392.4070706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030046.07152.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007 00:41:22 Ulrich Drepper wrote:
> Note the extra 's'.  We use "sse" and "sse2", but "ssse3".  I assume
> it's a typo.

Nope. SSE3 != SSSE3. The additional S means Supplemential.

It's probably because the few changes didn't justify a SSE4

-Andi
