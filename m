Return-Path: <linux-kernel-owner+w=401wt.eu-S1161141AbXBUJD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141AbXBUJD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161152AbXBUJD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:03:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55823 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161141AbXBUJDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:03:25 -0500
Date: Wed, 21 Feb 2007 11:03:23 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Arjan van de Ven <arjan@infradead.org>
cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 2/3] slab: export ksize to modules
In-Reply-To: <1172048210.3531.167.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702211102550.11282@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
 <1172048210.3531.167.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Arjan van de Ven wrote:
> Please specify the use in the description of the patch!

See [PATCH 3/3] unionfs: fix up slab abuses.

			Pekka
