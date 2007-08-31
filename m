Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXHaQjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXHaQjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbXHaQjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:39:35 -0400
Received: from lazybastard.de ([212.112.238.170]:35739 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbXHaQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:39:34 -0400
Date: Fri, 31 Aug 2007 18:35:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Dmitry Monakhov <dmonakhov@sw.ru>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
Message-ID: <20070831163502.GC5328@lazybastard.org>
References: <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com> <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com> <20070831072611.GK29452@kernel.dk> <Pine.LNX.4.64.0708310028160.14632@schroedinger.engr.sgi.com> <20070831074338.GL29452@kernel.dk> <Pine.LNX.4.64.0708310049110.14743@schroedinger.engr.sgi.com> <20070831081201.GO29452@kernel.dk> <Pine.LNX.4.64.0708310821140.16456@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0708310821140.16456@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 August 2007 08:22:45 -0700, Christoph Lameter wrote:
> 
> What do you mean by moving things around? Creation binds a filesystem to a 
> device.

Create the filesystem on a usb key, then move it to the next machine,
i suppose.

Or on any other movable medium, including disks, nbd, iSCSI,...

Jörn

-- 
Doubt is not a pleasant condition, but certainty is an absurd one.
-- Voltaire
