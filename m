Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbYFQXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbYFQXWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYFQXWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:22:12 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:38161 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759521AbYFQXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:22:11 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: mperkel@yahoo.com
Subject: Re: AMD Dual Core vs. Quad - Power Management
Date: Wed, 18 Jun 2008 00:22:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <364301.54904.qm@web52506.mail.re2.yahoo.com>
In-Reply-To: <364301.54904.qm@web52506.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806180022.08385.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2008 23:00:25 Marc Perkel wrote:
> Been running a few tests and an AMD motherboard booting 2.6.25 from flash
> uses 0.33 amps if the CPU is a AM2 Athlon 6000. But if I used a Phenom Quad
> core CPU 9550 it pulls 0.55 amps.
>
> In theory the 9550 should pull less because it's a lower TPD and the phenom
> processor is supposed to be smarter about power management.

Not all 6000+'s have the same TDP. Maybe you have an F3 stepping 6000+ which 
has an 89W TDP, lower than a quad core Phenom (which is 95W only AFAICT).

Doesn't really explain the power gulf, though.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
