Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZAFBue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZAFBue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZAFBuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:50:25 -0500
Received: from twin.jikos.cz ([213.151.79.26]:50717 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZAFBuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:50:25 -0500
Date: Tue, 6 Jan 2009 02:50:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       weidong.han@intel.com
Subject: Re: mmotm 2009-01-05-12-50 uploaded
In-Reply-To: <49628A1E.9080003@gmail.com>
Message-ID: <alpine.LRH.1.10.0901060247580.24105@twin.jikos.cz>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org> <49628A1E.9080003@gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Jiri Slaby wrote:

> > The mm-of-the-moment snapshot 2009-01-05-12-50 has been uploaded
> it fails to build here due to this link error:
> drivers/built-in.o: In function `alloc_iommu':
> (.text+0xf1bf): undefined reference to `iommu_calculate_agaw'

This is not a problem of mmotom, the same applies for Linus' tree. The 
patch exists [1], but it seems to be queued in Ingo's tree still.

[1] http://lkml.org/lkml/2009/1/4/35

-- 
Jiri Kosina
SUSE Labs

