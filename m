Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0BIFeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:34:50 -0500
Received: from ozlabs.org ([203.10.76.45]:34919 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0BIFet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:34:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] Remove reference to kthread_create_on_cpu
Date: Tue, 9 Feb 2010 16:04:43 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
References: <20100209040740.GB3702@kryten>
In-Reply-To: <20100209040740.GB3702@kryten>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002091604.43557.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010 02:37:40 pm Anton Blanchard wrote:
> 
> kthread_create_on_cpu doesn't exist so update a comment in kthread.c to
> reflect this.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
