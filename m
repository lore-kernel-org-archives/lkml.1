Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbXGNMoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbXGNMoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 08:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXGNMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 08:44:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:53350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXGNMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 08:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=e56/Dy5U2rgqd4xugZaJCHcm72rnFRZZeggrOIv4SQQBbZm4yd1UA4GpQ1CANgDHgy/E2/R/kpBPosP6k46h8wu1sAWIB7FfCh5r5W0vF5L0YTWmXoF3/d2oexevJnRSbKziBK5jIkxt/NKoePzryqbfBmOLP5hZ2mpcs08xaY0=
Message-ID: <4698C519.6040703@googlemail.com>
Date: Sat, 14 Jul 2007 14:44:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>
In-Reply-To: <4698BF14.10807@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
>
> doing a modprobe fixed the driver segfaults and I get this Oops:
>
>
> Jul 14 13:43:30 lara [  157.952915] Fixed PHY: Registered new driver
[...]

God , tbird sucks ..

There the dmesg with the Oops :

http://194.231.229.228/kern.log

Should be better to read.

Regards,

Gabriel

