Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZJFQxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZJFQxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZJFQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:53:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:10156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZJFQxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,513,1249282800"; 
   d="scan'208";a="195701682"
Date: Tue, 6 Oct 2009 09:52:51 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Message-ID: <20091006095251.0865d85f@jbarnes-g45>
In-Reply-To: <4AC97C00.7090503@kernel.org>
References: <4AC97C00.7090503@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Oct 2009 21:54:24 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> for intel system with multi IOH. we could read peer root resource
> from PCI conf, and don't trust _CRS again for root bus
> 
> v2: address change request from Ingo
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
