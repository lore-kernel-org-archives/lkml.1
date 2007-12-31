Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbXLaQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbXLaQo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXLaQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:44:12 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:39132 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXLaQoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:44:03 -0500
Date: Tue, 1 Jan 2008 01:11:33 +0900
To: balbir@linux.vnet.ibm.com, akpm@linux-foundation.org
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <4778E037.6000001@linux.vnet.ibm.com>
References: <4774A74B.3000105@linux.vnet.ibm.com>
	<20071228165115O.tomof@acm.org>
	<4778E037.6000001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080101011452P.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007 17:57:35 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > 
> > Oops, it's for -mm.
> > 
> 
> Hi,
> 
> I just tested this patch and it works fine for me so far.
> 
> Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Thanks!

I sent an updated patch including this fix several hours ago:

http://ozlabs.org/pipermail/linuxppc-dev/2007-December/048997.html
