Return-Path: <linux-kernel-owner+w=401wt.eu-S1764692AbXGJSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764692AbXGJSzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbXGJSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:55:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252AbXGJSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:55:31 -0400
Date: Tue, 10 Jul 2007 11:55:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI probing changes
Message-Id: <20070710115523.e95d833c.akpm@linux-foundation.org>
In-Reply-To: <200707101134.05725.jesse.barnes@intel.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707101134.05725.jesse.barnes@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:34:03 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

> On Tuesday, July 10, 2007 1:31:52 Andrew Morton wrote:
> > pci-disable-decode-of-io-memory-during-bar-sizing.patch
> 
> This is a core PCI change, should probably go through Greg and/or 
> linux-pci instead?  Or just send it to Linus directly, iirc everyone 
> was ok with the change for 2.6.23.

Ah, thanks.  I moved it to the gregkh-pci queue.

> Also, you can add a
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> to it.

Updated, thanks.
