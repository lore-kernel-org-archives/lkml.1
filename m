Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbZD0UnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbZD0UnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZD0UnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:43:07 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:48382 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbZD0UnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:43:06 -0400
Message-ID: <49F618D1.2050109@freescale.com>
Date: Mon, 27 Apr 2009 15:42:57 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: David Hawkins <dwh@ovro.caltech.edu>
CC: Liu Dave-R63238 <DaveLiu@freescale.com>, Ira Snyder <iws@ovro.caltech.edu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com> <49F6187F.8020703@ovro.caltech.edu>
In-Reply-To: <49F6187F.8020703@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Hawkins wrote:

> Ira will add your comment to the body of the code near
> the PRC_RM command and submit a new patch.

I'd rather have it near the top where people can see it.

-- 
Timur Tabi
Linux kernel developer at Freescale
