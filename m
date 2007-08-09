Return-Path: <linux-kernel-owner+w=401wt.eu-S966360AbXHIQzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966360AbXHIQzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935171AbXHIQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:55:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935118AbXHIQzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:55:04 -0400
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
References: <46BB4599.2020900@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Aug 2007 19:49:21 +0200
In-Reply-To: <46BB4599.2020900@redhat.com>
Message-ID: <p73zm10egym.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:
> 
> Initializing FS in the doublefault_tss should fix it.
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> 
> ---
> 
>  NOTE: not even compile tested.

Can you please test it?

-Andi
