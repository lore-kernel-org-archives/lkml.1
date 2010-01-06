Return-Path: <linux-kernel-owner+w=401wt.eu-S933054Ab0AFXUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab0AFXUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932665Ab0AFXUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:20:49 -0500
Received: from ozlabs.org ([203.10.76.45]:33030 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab0AFXUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:20:48 -0500
Date: Thu, 7 Jan 2010 10:20:24 +1100
From: Anton Blanchard <anton@samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
Message-ID: <20100106232024.GB12742@kryten>
References: <20100106045509.245662398@samba.org>
 <20100106045509.245662398@samba.org>
 <20100106045525.476396870@samba.org>
 <201001061706.26845.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001061706.26845.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,
 
> If you grep for the callers, you'll see those which do this (now-obsolete)
> check.  One more patch :)

Good point. I was hoping to have a chance at a -stable backport, so I'll
do this cleanup in a follow up patch.

Anton
