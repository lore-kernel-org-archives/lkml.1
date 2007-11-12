Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXKLVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXKLVQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXKLVQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:16:45 -0500
Received: from ns1.suse.de ([195.135.220.2]:35390 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbXKLVQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:16:44 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
Date: Mon, 12 Nov 2007 22:01:45 +0100
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071112181747.GE7296@cvg>
In-Reply-To: <20071112181747.GE7296@cvg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711122201.45269.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 19:17:47 Cyrill Gorcunov wrote:
> This patch does remove trailing spaces from
> source files.

That will just cause a zillion patches to not apply anymore
with exactly 0 benefit.

-Andi
