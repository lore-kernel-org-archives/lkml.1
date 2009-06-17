Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZFQCNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZFQCNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZFQCMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:12:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48494 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZFQCMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:12:52 -0400
Date: Tue, 16 Jun 2009 20:12:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Changli Gao <xiaosuo@gmail.com>
Cc: James.Bottomley@HansenPartnership.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_wait_scan: no option appears when configuring for
	scsi_wait_scan.
Message-ID: <20090617021254.GQ19977@parisc-linux.org>
References: <4A384FE4.9090703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A384FE4.9090703@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 10:07:32AM +0800, Changli Gao wrote:
> FIXBUG: missing comment after tristate leads to no option for
> scsci_wait_scan when configuring.

Please search the archives.  Patches along these lines have been rejected
before.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
