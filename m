Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYHDM5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYHDM5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYHDM44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:56:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:45050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYHDM4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:56:55 -0400
Date: Mon, 4 Aug 2008 14:56:50 +0200
From: Karsten Keil <kkeil@suse.de>
To: Sinan Akman <sinan@writeme.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>
Subject: Re: mISDN still breaking the allmodconfig build...
Message-ID: <20080804125650.GC20260@pingi.kke.suse.de>
References: <20080727.170235.97056809.davem@davemloft.net> <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org> <20080727.180736.74131389.davem@davemloft.net> <7949EA87-4340-4353-AFC9-79A718B95DF0@holtmann.org> <20080728084024.GA23465@pingi.kke.suse.de> <488DC046.7060802@writeme.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488DC046.7060802@writeme.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 08:49:10AM -0400, Sinan Akman wrote:
> Karsten Keil wrote:
> >[...]
> >virt_to_bus() I never got a complain before and yes I already have some 
> >patches
> >to solve the endian issues in the HFC driver, but it was not finaly
> 
>   Karsten, do you have those patches available somewhere ?
> I could give it a try on  4xx with a 4s card in the near future.
> 

Already fixed in
git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
