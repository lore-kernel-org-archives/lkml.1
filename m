Return-Path: <linux-kernel-owner+w=401wt.eu-S1946420AbXD3Q7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946420AbXD3Q7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946425AbXD3Q7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:59:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946420AbXD3Q7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:59:12 -0400
Date: Mon, 30 Apr 2007 19:56:53 +0200
From: Andi Kleen <ak@suse.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <ak@suse.de>, ebiederm@xmission.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/34] i386: convert the monitor thread to use the kthread API
Message-ID: <20070430175653.GE25929@bingen.suse.de>
References: <20070430549.617098000@suse.de> <20070430155003.ABE6663AC@wotan.suse.de> <1177952159.3674.39.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177952159.3674.39.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:55:59AM -0500, James Bottomley wrote:
> On Mon, 2007-04-30 at 17:50 +0200, Andi Kleen wrote:
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > This patch just trivially replaces kernel_thread and daemonize with a
> > single call to kthread_run.
> 
> Actually, no, I'm checking out Christoph's full conversion now.  If it
> works, I'll send it in via the voyager tree.

Dropped
-Andi
