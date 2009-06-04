Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZFDMZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZFDMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZFDMZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:25:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58329 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbZFDMZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:25:15 -0400
Message-ID: <4A27BD29.3070709@redhat.com>
Date: Thu, 04 Jun 2009 15:25:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v5 0/2] iosignalfd
References: <20090603200835.8206.8039.stgit@dev.haskins.net> <4A26ED22.4060203@novell.com>
In-Reply-To: <4A26ED22.4060203@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Marcello, Avi, and myself have previously agreed that Marcello's
> mmio-locking cleanup should go in first.   When that happens, I will
> need to rebase this series because it changes how you interface to the
> io_bus code.  I should have mentioned that here, but forgot.  (Speaking
> of, is there an ETA when that code will be merged Avi?)
>   

I had issues with the unbalanced locking the patchset introduced in 
coalesced_mmio, once these are resolved the patchset will be merged.

-- 
error compiling committee.c: too many arguments to function

