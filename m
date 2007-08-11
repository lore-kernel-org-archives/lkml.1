Return-Path: <linux-kernel-owner+w=401wt.eu-S1765226AbXHKDMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765226AbXHKDMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 23:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXHKDMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 23:12:13 -0400
Received: from ozlabs.org ([203.10.76.45]:35463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761380AbXHKDMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 23:12:12 -0400
Subject: Re: [PATCH 5/7] Change lguest launcher to use asm generic include
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
In-Reply-To: <20070809003343.829371800@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
	 <20070809003343.829371800@goodmis.org>
Content-Type: text/plain
Date: Sat, 11 Aug 2007 13:11:33 +1000
Message-Id: <1186801893.30899.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 20:32 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0005-Change-lguest-launcher-to-use-asm-generic-include-instead-of-explicitly.txt)
> Have the lguest launcher include e820.h via asm/e820.h instead of explicitly
> saying i386.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Applied, thanks,

Rusty.


