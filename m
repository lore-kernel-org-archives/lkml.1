Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYBRQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYBRQL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYBRQLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:11:48 -0500
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:24345 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbYBRQLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:11:47 -0500
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Kernel Ooops while running dbench
Cc: akpm@linux-foundation.org, apw@shadowen.org, balbir@linux.vnet.ibm.com,
       clameter@sgi.com, kamalesh@linux.vnet.ibm.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-To: <47B9956B.8060506@garzik.org>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B6784E.2090401@linux.vnet.ibm.com> <20080218045954.50503fb1.akpm@linux-foundation.org> <20080218045954.50503fb1.akpm@linux-foundation.org> <47B9956B.8060506@garzik.org>
Message-Id: <E1JR8aj-0004bH-Er@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Mon, 18 Feb 2008 17:11:41 +0100
X-OriginalArrivalTime: 18 Feb 2008 16:11:41.0867 (UTC) FILETIME=[F2E9A7B0:01C87248]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Two x86-64 boxes here lock up here on 2.6.25-rc2, shortly after boot.
> One running Fedora 8 + X (GNOME) and one a headless file server.
> configs and lspci attached.  Unable to capture any splatter so far.

Sounds like it may be http://lkml.org/lkml/2008/2/17/78.

Suggest you try reverting that before doing the bisect.

Cheers,
FJP
