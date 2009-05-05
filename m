Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZEETRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZEETRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZEETRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:17:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:59023 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZEETRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,299,1239001200"; 
   d="scan'208";a="139473538"
Date: Tue, 5 May 2009 12:16:58 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] PCI: remove deprecated pci_find_slot() interface
Message-ID: <20090505121658.11e881bb@hobbes>
In-Reply-To: <20090331152422.26622.85161.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
	<20090331152422.26622.85161.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 09:24:22 -0600
Alex Chiang <achiang@hp.com> wrote:

> The last in-tree caller of pci_find_slot has been converted, so
> let's get rid of this deprecated interface.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

Ok applied this series.  No more pci_find_slot, yay!

-- 
Jesse Barnes, Intel Open Source Technology Center
