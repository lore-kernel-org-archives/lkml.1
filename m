Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYDXWvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYDXWvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYDXWvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:51:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYDXWvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:51:22 -0400
Date: Thu, 24 Apr 2008 15:51:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, jbarnes@virtuousgeek.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: gregkh-02-pci tree is now gone
Message-ID: <20080424225104.GA16529@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, Andrew,

My gregkh-02-pci tree is now gone as Jesse is now the PCI maintainer.
I'll let him tell you all where to get his PCI patch queue from as I
have no idea.

This means that my other trees have been renamed, so you might want to
adjust your scripts accordingly:
	gregkh-01-driver_core 	->  gregkh-01-driver_core   (no change)
	gregkh-03-usb		->  gregkh-02-usb
	gregkh-04-ldp		->  gregkh-03-ldp

They are still located in the same directory on kernel.org as before at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/


thanks,

greg k-h
