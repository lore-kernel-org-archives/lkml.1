Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZFIHwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZFIHwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZFIHwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:52:06 -0400
Received: from ozlabs.org ([203.10.76.45]:35912 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbZFIHwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:52:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch 4/5] module: trim exception table in module_free()
Date: Tue, 9 Jun 2009 17:21:54 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, hch@infradead.org, akpm@linux-foundation.org
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain> <20090607121549.GA31173@elte.hu> <4A2C6B0E.9090702@redhat.com>
In-Reply-To: <4A2C6B0E.9090702@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091721.59031.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 11:06:14 am Amerigo Wang wrote:
> Ingo Molnar wrote:
> > I think it makes most sense to handle them together. We have no
> > interacting changes pending in the x86 tree, feel free to pick them
> > up.
>
> Thanks for clarifying.
>
> So, Rusty, could you please take all of these except patch 4/5? Since you
> have a much better one to replace that one. :)

Yep, I've put them in my tree for testing; if all goes well, they'll hit 
linux-next in a couple of days.

Thanks!
Rusty.
