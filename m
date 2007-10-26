Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbXJZQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbXJZQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXJZQpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:45:04 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:49433 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764843AbXJZQpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:45:01 -0400
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.624-rc1 regression] lost battery information
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-To: <200710262024.06012.arvidjaar@mail.ru>
References: <200710262024.06012.arvidjaar@mail.ru>
Message-Id: <E1IlSIs-0006qT-Kc@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 26 Oct 2007 18:44:58 +0200
X-OriginalArrivalTime: 26 Oct 2007 16:44:58.0894 (UTC) FILETIME=[8BBA8AE0:01C817EF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> I have lost battery in 2.6.24-rc1. Without CONFIG_ACPI_PROCFS I have
> no /proc/acpi/battery and cannot test netlink interface because right now
> there is no consumer of this.

This is a known issue. Please see:
http://lkml.org/lkml/2007/10/22/110

Cheers,
Frans Pop
