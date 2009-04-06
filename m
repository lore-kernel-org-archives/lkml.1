Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZDFSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZDFSqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbZDFSqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:46:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:55307 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941AbZDFSqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:46:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="445476555"
Date: Mon, 6 Apr 2009 11:46:18 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090406114618.16cb86ef@hobbes>
In-Reply-To: <20090402002412.GB28975@ldl.fc.hp.com>
References: <20090331121331.3673cf59@hobbes>
	<alpine.LFD.2.00.0904010957520.4130@localhost.localdomain>
	<20090401101309.67d0bea5@hobbes>
	<20090402002412.GB28975@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 18:24:12 -0600
Alex Chiang <achiang@hp.com> wrote:

> PCI: annotate pci_rescan_bus as __ref, not __devinit

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
