Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXLJC7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXLJC7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXLJCtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:49:16 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:3538 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396AbXLJCtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:49:15 -0500
To: Alexander Rajula <chris@nerdmail.nu>
Subject: Re: PROBLEM: /proc/cpuinfo reports erroneous CPU frequency. (2.6.23 &  2.6.22)
Cc: linux-kernel@vger.kernel.org
In-reply-To: <475C9B06.9000901@nerdmail.nu>
References: <475C9B06.9000901@nerdmail.nu>
Message-Id: <E1J1Yhk-00019U-1J@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Mon, 10 Dec 2007 03:49:12 +0100
X-OriginalArrivalTime: 10 Dec 2007 02:49:12.0311 (UTC) FILETIME=[3E9FF870:01C83AD7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Rajula wrote:
> While overclocking an AMD Athlon X2 (2GHz) CPU /proc/cpuinfo reports the
> wrong CPU frequency. I am quite puzzled by this.
> Is this an error in the kernel, or is there something strange going on?

You may want to read some old threads on this list and check if that matches
what you are seeing:
http://lkml.org/lkml/2006/3/29/150
http://lkml.org/lkml/2006/10/26/182

Cheers,
FJP
