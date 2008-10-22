Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYJVSz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYJVSz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbYJVSv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:59 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:53875 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbYJVSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:58 -0400
Date: Wed, 22 Oct 2008 14:51:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
In-reply-to: <20081022152013.GB25548@elf.ucw.cz>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Yan Burman <burman.yan@gmail.com>,
       Pau Oliva Fora <pau@eslack.org>
Message-id: <alpine.LFD.1.10.0810221446100.3010@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <48FA3368.1040605@tremplin-utc.net>
 <20081022152013.GB25548@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct acpi_device_id lis3lv02d_device_ids[] = {
> +       {"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */

Has HP provided any documentation or engineering support
to help support this work?

Note that other laptop drivers that utilize vendor-specific
ACPI hooks tend to live under drivers/misc -- for lack
of a better home.

thanks,
-Len

