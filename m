Return-Path: <linux-kernel-owner+w=401wt.eu-S1030269AbXCAVbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269AbXCAVbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXCAVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:31:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37973 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030269AbXCAVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:31:15 -0500
Date: Thu, 1 Mar 2007 16:30:55 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shmem and simple const super_operations
Message-ID: <20070301213054.GB7664@filer.fsl.cs.sunysb.edu>
References: <Pine.LNX.4.64.0703011915460.17890@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703011915460.17890@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 07:22:32PM +0000, Hugh Dickins wrote:
> shmem's super_operations were missed from the recent const-ification;
> and simple_fill_super()'s, which can share with get_sb_pseudo()'s.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS
