Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZGVWnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZGVWnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZGVWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:43:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57433 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752936AbZGVWnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:43:10 -0400
Date: Wed, 22 Jul 2009 23:44:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Message-ID: <20090722234403.650c0af3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090722222501.GA20860@redhat.com>
References: <200907221926.50397.pavel@pavlinux.ru>
	<20090722213746.GA20241@redhat.com>
	<200907230158.15417.pavel@pavlinux.ru>
	<20090722222501.GA20860@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Removing the select creates a potential for people to load video drivers
> that don't come with the kernel to corrupt data as soon as something
> writes using the IOMMU.

"Video drivers that don't come with the kernel"

How about some specifics ?
