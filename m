Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbXBUIWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbXBUIWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXBUIWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:22:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35187 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbXBUIWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:22:52 -0500
Date: Wed, 21 Feb 2007 10:22:50 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Muli Ben-Yehuda <muli@il.ibm.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 2/3] slab: export ksize to modules
In-Reply-To: <20070221081443.GC2857@rhun.haifa.ibm.com>
Message-ID: <Pine.LNX.4.64.0702211021200.9548@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
 <20070221081443.GC2857@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Muli,

On Wed, Feb 21, 2007 at 10:06:52AM +0200, Pekka J Enberg wrote:
> > This exports ksize in slab and slob allocators to modules.

On Wed, 21 Feb 2007, Muli Ben-Yehuda wrote:
> That's a pretty generic name... if it's going to be part of the module
> API, it should be renamed to something a bit more obvious.

Well, it is the established slab API so I am bit relucant to change it. 
But if someone comes up with a better name, why not...

				Pekka
