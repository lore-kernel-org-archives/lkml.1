Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXGQE6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXGQE6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXGQE6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:58:00 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:59683 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXGQE57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JZHkoUaK5RSyIT6c7QMQyi2L+7650lQV3t5xR/pYVFNvlDCg+mOBgI2rk39R9aAT1+lrZmLuUv9AiXxgmQz5VWlaR8xwPG+w4BzFCxCqaSJBR+MxXCn8eUuHScvcUPUXuP9+bUkxe7rzCa/9QR6Hsbf/7WQ28B4Dt3F7bc2EDu0=
Date: Tue, 17 Jul 2007 00:57:26 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
Message-ID: <20070717045726.GC20082@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 04:57:06PM -0700, Andrew Morton wrote:

> What does the code in bsg.c _do_, anyway??  Ho hum.

    It reformats the hard drive on Battlestar Galactica before the
Cylon virus that has penetrated the firewalls keeps the power off long
enough for the Centurions to vent the crew into space.  (I believe it
used BSG disk slices).

--
Joseph Fannin
jfannin@gmail.com

/me suspects he has used his ration of inanity for about a year or so.

