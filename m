Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZHCG4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZHCG4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZHCG4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:56:42 -0400
Received: from ozlabs.org ([203.10.76.45]:60834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZHCG4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:56:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] Virtio 9p: get rid of redundant VIRTIO_ID_9P definition
Date: Mon, 3 Aug 2009 16:26:38 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: ericvh@gmail.com, v9fs-developer@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4A726051.8080705@oss.ntt.co.jp>
In-Reply-To: <4A726051.8080705@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908031626.38394.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 12:39:05 pm Fernando Luis Vázquez Cao wrote:
> VIRTIO_ID_9P is already defined in include/linux/virtio_9p.h
> so use that definition instead.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Thanks, applied.

Rusty.
