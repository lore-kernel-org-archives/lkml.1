Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbXKASNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbXKASNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbXKASNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:13:05 -0400
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:47793 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbXKASNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:13:04 -0400
To: Chris Holvenstot <cholvenstot@comcast.net>
Subject: Re: Issue building kernel driver
Cc: linux-kernel@vger.kernel.org
In-reply-To: <1193938746.7555.7.camel@localhost>
References: <1193938746.7555.7.camel@localhost>
Message-Id: <E1IneXG-0003NJ-7z@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Thu, 01 Nov 2007 19:12:54 +0100
X-OriginalArrivalTime: 01 Nov 2007 18:13:01.0660 (UTC) FILETIME=[D6FB29C0:01C81CB2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot wrote:
> Since I try to be slightly useful and build as many of the "test" kernel
> images I can I end up rebuilding the VirtualBox kernel driver (open
> source) on an almost daily basis.
> 
> I attempted to rebuild the driver today and got the following error
> messages running 2.6.24-rc1-git9

I had the same issue and managed to work around it. See:
http://vbox.innotek.de/pipermail/vbox-users/2007-October/002372.html

Cheers,
FJP
