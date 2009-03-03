Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZCCQje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZCCQje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZCCQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:39:09 -0500
Received: from www.tglx.de ([62.245.132.106]:42860 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZCCQjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:39:08 -0500
Date: Tue, 3 Mar 2009 17:38:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpumask: remove references to struct irqaction's
 mask field.
In-Reply-To: <200902131238.52419.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0903031737380.29264@localhost.localdomain>
References: <200902131238.52419.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty,

On Fri, 13 Feb 2009, Rusty Russell wrote:

> It's unused, since about 1995.  So remove all initialization of it in
> preparation for actually removing the field.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.

thanks a lot ! I was just about to do the same :)

Acked-by: Thomas Gleixner <tglx@linutronix.de>
