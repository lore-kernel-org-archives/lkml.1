Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZATNUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZATNUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbZATNTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:19:52 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:34760 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761664AbZATNTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:19:51 -0500
From: Ionut Leonte <ionut.leonte@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.28 changes in-kernel name for UVC device ?
Date: Tue, 20 Jan 2009 15:19:44 +0200
User-Agent: KMail/1.9.9
References: <200901201349.33707.ionut.leonte@gmail.com> <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com>
In-Reply-To: <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901201519.44347.ionut.leonte@gmail.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.23258
X-BitDefender-Spam: No (7)
X-BitDefender-SpamStamp: v1, build 2.7.20.59391, bayes score: 500(0),
 pbayes score: 241(7), neunet score: 0(0), flags: [VALID_REPLY],
 total: 7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009 15:07:21 you wrote:
> These rules are broken, and match also on firewire devices and not
> only video4linux devices.
>
> Such rules are not part of the standard udev setup and need to be
> fixed to work as intended. There is no change or fault at the kernel
> side. You may just disable the firefire drivers if you don't need
> them.
>
> Btw, swapping default kernel names to devfs names and create symlinks
> for the kernel names is not recommended at all.

Thanks for the clarifications. The rule is taken from the 'default' udev setup 
as presented to me by my distribution (Gentoo in my case). I'll be sure to 
file a bug report with them.

Cheers.
