Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbXDJWJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbXDJWJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbXDJWJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:09:30 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40960 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbXDJWJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:09:29 -0400
Date: Wed, 11 Apr 2007 00:09:01 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <461C09D6.40805@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0704110006320.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <461C09D6.40805@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 00:04, Stefan Richter wrote:
>
>[...] I tried one of the patches
>  - with make xconfig: OK
>  - with make gconfig: OK
>  - with make menuconfig: less so, because:
>When one switches a menuconfig _on_, one might miss that there are
>subsequent options to configure.  (Although the availability of further
>options is indicated by the '--->' suffix to the menu title.)

The kconfig files had some menuconfigs for some time (CONFIG_EMBEDDED to be
one). I do not think these menu entry types are unknown.

Jan
-- 
