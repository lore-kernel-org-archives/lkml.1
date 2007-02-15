Return-Path: <linux-kernel-owner+w=401wt.eu-S965658AbXBOLTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658AbXBOLTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXBOLTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:19:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965658AbXBOLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:19:30 -0500
Date: Thu, 15 Feb 2007 06:19:20 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unify pcspeaker platform device code between i386/x86-64
Message-ID: <20070215111920.GC8353@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200702150901.l1F910lp023036@hera.kernel.org> <45D4299D.6000906@garzik.org> <200702151049.57943.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702151049.57943.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 10:49:57AM +0100, Andi Kleen wrote:
 > 
 > > It's always seemed broken (though perhaps this was a distro bug?) in 
 > > module form, so I've been compiling it in to get it to work.
 > 
 > Must have been a distro bug. It should have worked before as long 
 > as the config was enabled.

If so, I'm not sure what distro Jeff was running, as it worked
fine in Fedora for some time on both 32bit and 64bit x86 for me.

		Dave

-- 
http://www.codemonkey.org.uk
