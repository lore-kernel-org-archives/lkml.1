Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbZJFQLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbZJFQLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbZJFQLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:11:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:30365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbZJFQLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:11:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,513,1249282800"; 
   d="scan'208";a="454987915"
Date: Tue, 6 Oct 2009 09:11:05 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Gabe Black <gabe.black@ni.com>
Cc: shawn.bohrer@ni.com, mike.hoogendyk@ni.com, knan@anduin.net,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org, Gabe Black <gabe.black@ni.com>
Subject: Re: [PATCH] TI XIO200a bridge quirk: erroneously reports support
 for fast b2b transfers
Message-ID: <20091006091105.2f4c0d5d@jbarnes-g45>
In-Reply-To: <1254838785-10254-1-git-send-email-gabe.black@ni.com>
References: <8a15eb2b0910060432m3c062776md718ea19baf19a3f@mail.gmail.com>
	<1254838785-10254-1-git-send-email-gabe.black@ni.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 09:19:45 -0500
Gabe Black <gabe.black@ni.com> wrote:

> This quirk will disable fast back to back transfer on the secondary
> bus segment of the TI Bridge.
> 
> Signed-off-by: Gabe Black <gabe.black@ni.com>

Applied to my for-linus branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
