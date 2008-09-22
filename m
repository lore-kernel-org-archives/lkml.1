Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYIVSU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYIVSU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYIVSUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:20:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35718 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYIVSUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:20:48 -0400
Date: Mon, 22 Sep 2008 11:19:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org, avi@qumranet.com,
       kvm@vger.kernel.org
Subject: Re: mmotm 2008-09-22-01-36 uploaded (kvm)
Message-Id: <20080922111947.507e34b1.randy.dunlap@oracle.com>
In-Reply-To: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc7:



ERROR: "intel_iommu_found" [arch/x86/kvm/kvm.ko] undefined!

when CONFIG_DMAR=n.

---
~Randy
