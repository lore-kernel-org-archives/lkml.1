Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYHNEmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYHNEmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 00:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYHNEmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 00:42:37 -0400
Received: from ozlabs.org ([203.10.76.45]:55121 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYHNEmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 00:42:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] virtio_blk: use a wrapper function to access io context information of IO requests
Date: Thu, 14 Aug 2008 14:42:09 +1000
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?utf-8?q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp> <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp> <1218615271.16667.38.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1218615271.16667.38.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808141442.09633.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008 18:14:31 Fernando Luis Vázquez Cao wrote:
> Rusty, Jens
>
> What do you think about the patch below? Does it make sense?

Yes.  Obviously it makes more sense for Jens to queue this so:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
