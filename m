Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYBFIar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYBFIar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758751AbYBFIaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:30:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758432AbYBFIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:30:38 -0500
Date: Wed, 6 Feb 2008 00:30:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Michael Bussmann <bus@mb-net.net>, linux-kernel@vger.kernel.org
Subject: Re: OOM killer on idle machine
Message-Id: <20080206003024.a235f71c.akpm@linux-foundation.org>
In-Reply-To: <20080205110818.GA8333@linux.vnet.ibm.com>
References: <20080205100423.GA12009@ruf099.fkie.fgan.de>
	<20080205110818.GA8333@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 16:38:18 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> > Feb  4 16:35:56 kernel: 4426 pages slab
> > Feb  4 16:35:56 kernel: 360 pages pagetables
> > 
> 
> Looks like quicklists again.

Are you sure?  Normally there will be large amounts of memory in slab
when that one occurs?
