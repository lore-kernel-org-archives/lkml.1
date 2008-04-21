Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYDUNRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYDUNRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYDUNQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:16:53 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:3892 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbYDUNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:16:53 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 09:16:52 EDT
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
To: grundler@parisc-linux.org (Grant Grundler)
Date: Mon, 21 Apr 2008 09:07:41 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
In-Reply-To: <20080421050029.GC15080@colo.lackof.org> from "Grant Grundler" at Apr 20, 2008 11:00:29 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20080421130742.79F9D4DE4@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Releasing cpu 1 now, hpa=fffffffffffa2000
> > SMP: CPU:1 is stuck.
> 
> BTW, I'm not sure this is a kernel problem. Do older kernels still work?

I'm not sure this is related but a few months ago I noticed that only
two of the four cpus in the rp3440 that I have were running.  I reenabled
the two cpus that were not running, but I had to do it a couple of more
times before the two cpus remained enabled across reboots.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
