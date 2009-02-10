Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZBJLcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZBJLcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZBJLck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:32:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:54554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZBJLch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:32:37 -0500
Subject: Re: [PATCH v2 1/6] PCI: support the ATS capability
From: David Woodhouse <dwmw2@infradead.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1232252254-7614-2-git-send-email-yu.zhao@intel.com>
References: <1232252254-7614-1-git-send-email-yu.zhao@intel.com>
	 <1232252254-7614-2-git-send-email-yu.zhao@intel.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 11:32:30 +0000
Message-Id: <1234265550.10484.62.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 12:17 +0800, Yu Zhao wrote:
> The ATS spec can be found at http://www.pcisig.com/specifications/iov/ats/
> (it requires membership).
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

If I can have an ack from Jesse for the PCI bits (which is basically
this patch), I'll take the whole lot through my iommu tree. OK?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

