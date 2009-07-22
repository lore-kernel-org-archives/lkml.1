Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbZGVEa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbZGVEa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZGVEa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:30:27 -0400
Received: from ozlabs.org ([203.10.76.45]:41791 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZGVEa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:30:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] percpu: kill legacy percpu allocator
Date: Wed, 22 Jul 2009 14:00:19 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org,
       x86@kernel.org, andi@firstfloor.org
References: <1248171979-29166-1-git-send-email-tj@kernel.org> <4A65B314.1000907@kernel.org>
In-Reply-To: <4A65B314.1000907@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221400.21969.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 09:52:44 pm Tejun Heo wrote:
>  include/linux/percpu.h |   24 ------
>  kernel/module.c        |  150 -----------------------------------------

FWIW, I'm looking fwd to this.  module.c doesn't shrink very often :)

Thanks,
Rusty.
