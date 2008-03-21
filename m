Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYCUNGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYCUNGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCUNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:06:06 -0400
Received: from verein.lst.de ([213.95.11.210]:50872 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYCUNGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:06:05 -0400
Date: Fri, 21 Mar 2008 14:05:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: torvalds@osdl.org, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Why is the rewritten ramdisk driver called brd instad of rd
Message-ID: <20080321130552.GA28274@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any reason why the rewritten ramdisk driver has a new name?  It's for
all matters an inplace replacement of the old rd driver so it should
be called rd.c / rd.ko to not confused instaler/developers/etc.
