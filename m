Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYCDICO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYCDICO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYCDIBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:01:23 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:58482 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395AbYCDIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:01:21 -0500
Date: Tue, 4 Mar 2008 09:01:13 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       linux-usb@vger.kernel.org
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <20080303234913.f63e5fcb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.0803040858100.5974@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803030058280.5974@sheep.housecafe.de> <20080303234913.f63e5fcb.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Andrew Morton wrote:
> On Mon, 3 Mar 2008 01:05:53 +0100 (CET) Christian Kujau <lists@nerdbynature.de> wrote:
>> after upgrading to 2.6.25-rc3, kern.log shows:
>
> From which kernel version did you upgrade?

I upgraded from 2.6.24.1. I did not try the last -rc kernels due to lack 
of (free) time :-\

C.
-- 
BOFH excuse #405:

Sysadmins unavailable because they are in a meeting talking about why they are unavailable so much.
