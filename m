Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZHRR7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZHRR7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZHRR7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:59:12 -0400
Received: from kroah.org ([198.145.64.141]:33785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZHRR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:59:12 -0400
Date: Tue, 18 Aug 2009 10:34:10 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: sep: should depend on PCI
Message-ID: <20090818173410.GD6123@kroah.com>
References: <1250588932-7595-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250588932-7595-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:48:51PM +0400, Alexander Beregalov wrote:
> Fix this build error when CONFIG_PCI is not set
> drivers/staging/sep/sep_driver.c:2548: error: implicit declaration of function 'pci_dev_get'

This is now in linux-next as it came from someone else.

thanks,

greg k-h
