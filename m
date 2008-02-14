Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbYBNBOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbYBNBOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935463AbYBNBNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:13:51 -0500
Received: from www.tglx.de ([62.245.132.106]:55355 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934578AbYBNBNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:13:50 -0500
Date: Thu, 14 Feb 2008 02:13:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeff Garzik <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
In-Reply-To: <200802132339.19764.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802140146551.12988@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <200802132339.19764.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Rafael J. Wysocki wrote:

> Hi Thomas,
> 
> On Thursday, 7 of February 2008, Thomas Gleixner wrote:
> > current mainline triggers:
> 
> Has the issue been fixed in the meantime?

Nope. 

Just for reference: http://lkml.org/lkml/2007/1/14/38 looks
frighteningly similar.

Thanks,

	tglx
