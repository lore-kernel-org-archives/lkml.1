Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0BRMfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:35:31 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:58048 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab0BRMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:35:28 -0500
Date: Thu, 18 Feb 2010 13:35:17 +0100
From: lkml@Think-Future.de
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: use dma_alloc_coherent
Message-ID: <20100218123517.GC2165@localhost>
Reply-To: lkml@Think-Future.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210130744.GA3935@dhcp-lab-161.englab.brq.redhat.com>
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

Ignorant when this patch was included, the reported problems ceased to show up.

Running 2.6.32.7 since 6th of february.

reboot   system boot  2.6.32.7         Sat Feb  6 16:53 - 13:22 (11+20:29)

I'll report back if needed.

Thank you for your work and time!

Nils

@Andrew: Thanks for clarifying the oops/warning diff. I was probably too lazy too care about that 
  when it just made me loosing my connectivity.. sorta user-experience-drownded stuff.. ;)

