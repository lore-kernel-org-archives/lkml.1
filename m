Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZBLBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZBLBH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBLBHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:07:17 -0500
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:58057 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752546AbZBLBHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:07:16 -0500
Date: Wed, 11 Feb 2009 20:08:56 -0500
From: Ed Cashin <ecashin@coraid.com>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       karaluh@karaluh.pl
Subject: Re: [PATCH 1/1] aoe: ignore vendor extension AoE responses
Message-ID: <20090212010856.GB8636@coraid.com>
References: <1234397804-9034-1-git-send-email-ecashin@coraid.com> <20090211162944.c1cdf8fb.akpm@linux-foundation.org> <20090212003505.727354e9@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212003505.727354e9@lithium.local.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:35:05AM +0000, Alex Buell wrote:
> On Wed, 11 Feb 2009 16:29:44 -0800, I waved a wand and this message
> magically appears in front of Andrew Morton:
> 
> > Do you believe that this fix should be backported into earlier kernel
> > versions?  (2.6.28.x, 2.6.27.x, etc)
> 
> Yes, please - I'll be using AoE on these kernels. It might also be a
> good opportunity to update the AoE module, as I believe the latest out
> of the kernel tree module is currently at 70, whilst the version in
> 2.6.27 is at 47.

Yes, my intention is to regularly push patches now that I understand
linux-next and have a quilt tree in place to push patches to it.

-- 
  Ed Cashin <ecashin@coraid.com>
