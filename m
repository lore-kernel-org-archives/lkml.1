Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbXGJShp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbXGJShp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbXGJSh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:37:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:23615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764350AbXGJSh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:37:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,523,1175497200"; 
   d="scan'208";a="248759509"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PCI probing changes
Date: Tue, 10 Jul 2007 11:34:03 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101134.05725.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 10, 2007 1:31:52 Andrew Morton wrote:
> pci-disable-decode-of-io-memory-during-bar-sizing.patch

This is a core PCI change, should probably go through Greg and/or 
linux-pci instead?  Or just send it to Linus directly, iirc everyone 
was ok with the change for 2.6.23.

Also, you can add a
Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
to it.

Thanks,
Jesse
