Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYD3Fea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYD3Fea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 01:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYD3FeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 01:34:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbYD3FeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 01:34:21 -0400
Date: Tue, 29 Apr 2008 22:34:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gregkh-02-pci tree is now gone
Message-Id: <20080429223412.0e8f135d.akpm@linux-foundation.org>
In-Reply-To: <20080424225104.GA16529@kroah.com>
References: <20080424225104.GA16529@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 15:51:04 -0700 Greg KH <greg@kroah.com> wrote:

> Stephen, Andrew,
> 
> My gregkh-02-pci tree is now gone as Jesse is now the PCI maintainer.
> I'll let him tell you all where to get his PCI patch queue from as I
> have no idea.
> 
> This means that my other trees have been renamed, so you might want to
> adjust your scripts accordingly:
> 	gregkh-01-driver_core 	->  gregkh-01-driver_core   (no change)
> 	gregkh-03-usb		->  gregkh-02-usb
> 	gregkh-04-ldp		->  gregkh-03-ldp
>
> They are still located in the same directory on kernel.org as before at:
> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> 

What is gregkh-03-ldp?
