Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXBJPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXBJPvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 10:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbXBJPvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 10:51:36 -0500
Received: from dsl3-63-249-91-56.cruzio.com ([63.249.91.56]:37644 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXBJPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 10:51:35 -0500
Date: Sat, 10 Feb 2007 07:51:20 -0800
From: Andrew Burgess <aab@cichlid.com>
Message-Id: <200702101551.l1AFpKUf019229@cichlid.com>
To: mingo@elte.hu, rncbc@rncbc.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rt5 Oops on boot
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I have terrible news: 2.6.20-rt5 does not boot at all on a couple
>machines I was brave enough to try -- a P4@3.3Ghz SMP/HT desktop, and a
>Core2 Duo T7200@2.0Ghz laptop.

Ditto for me on an ASUS AMD64 x2, just hangs, I have no
serial console. 2.6.20-rc5-rt7 booted ok (the last one I
tried). Both using SMP.

