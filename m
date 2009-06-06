Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZFFPDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZFFPDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 11:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZFFPDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 11:03:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44801 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752174AbZFFPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 11:03:00 -0400
Date: Sat, 6 Jun 2009 16:04:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yunpeng Gao <yunpeng.gao@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Message-ID: <20090606160413.08c254cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20090606164455.GB27257@intel.com>
References: <20090606164455.GB27257@intel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jun 2009 00:44:55 +0800
Yunpeng Gao <yunpeng.gao@intel.com> wrote:

> Hi Greg,
> 
>    This is the first Intel Moorestown NAND driver patch for mainline. I
>    generated it and complie it against Linus' kernel tree, tag v2.6.30-rc8.

Flash drivers should go to David Woodhouse <dwmw2@infradead.org> as he
maintains the mtd  layer flash support code (which you don't seem to be
using ?)
