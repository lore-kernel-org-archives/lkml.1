Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYG3ABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYG3ABU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYG3ABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:01:12 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:9092 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYG3ABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:01:11 -0400
X-BigFish: VPS-18(z37d4l34a4l518kz1432R98dR4015M1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <488FAFE3.4040001@am.sony.com>
Date: Tue, 29 Jul 2008 17:03:47 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marco Berizzi <pupilla@hotmail.com>
CC: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console
 on slackware 12.1
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl>
In-Reply-To: <BAY103-W38794846AA924235B38E47B2820@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 00:00:54.0423 (UTC) FILETIME=[56104A70:01C8F1D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizzi wrote:
> alistair@devzero.co.uk wrote:
> 
>> You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?
> 
> yes console_translation is set to yes. It cannot be changed if embedded is not
> set.

If console_translation is set to yes, the behavior should be unchanged from
2.6.26.  Can you please send me your .config?

Also, can you please describe what breakage you are seeing?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

