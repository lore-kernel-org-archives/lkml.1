Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYJTQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYJTQoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJTQoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:44:07 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37002 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbYJTQoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:44:06 -0400
Date: Mon, 20 Oct 2008 12:44:04 -0400
To: n0ano@n0ano.com
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081020164404.GE22851@csclub.uwaterloo.ca>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810170846.41032.bjorn.helgaas@hp.com> <20081017153652.GH14490@xolotl.n0ano.com> <200810171039.53395.bjorn.helgaas@hp.com> <20081017170638.GJ14490@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017170638.GJ14490@xolotl.n0ano.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 11:06:38AM -0600, n0ano@n0ano.com wrote:
> We could do that but now the `clock' value becomes a very large
> number that is very magic.  Putting in the highest baud rate seems
> to make more sense than some magic number.

Yeah, and isn't that usually called the base_baud or something like
that?

-- 
Len Sorensen
