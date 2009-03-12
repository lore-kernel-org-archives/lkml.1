Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZCLWzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZCLWzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZCLWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:54:54 -0400
Received: from ozlabs.org ([203.10.76.45]:53449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZCLWyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:54:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Fri, 13 Mar 2009 09:24:48 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <20090312102645.GA25792@elte.hu> <20090312103733.GA29585@elte.hu>
In-Reply-To: <20090312103733.GA29585@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130924.48885.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 21:07:33 Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > Phew.  One core patch (the first one), the rest x86-specific.
> 
> hm, how much testing did this tree get? It crashes fast and hard 
> in -tip testing:

Missing a core patch (it even got a compile warning with that config).

But there's something else wrong.  Firing up my 64-bit test box now.

Sorry,
Rusty.
