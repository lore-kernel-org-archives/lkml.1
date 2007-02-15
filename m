Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXBOJ62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXBOJ62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 04:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965421AbXBOJ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 04:58:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:53567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418AbXBOJ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 04:58:27 -0500
From: Andi Kleen <ak@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] x86: Unify pcspeaker platform device code between i386/x86-64
Date: Thu, 15 Feb 2007 10:49:57 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200702150901.l1F910lp023036@hera.kernel.org> <45D4299D.6000906@garzik.org>
In-Reply-To: <45D4299D.6000906@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151049.57943.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's always seemed broken (though perhaps this was a distro bug?) in 
> module form, so I've been compiling it in to get it to work.

Must have been a distro bug. It should have worked before as long 
as the config was enabled.

-Andi
