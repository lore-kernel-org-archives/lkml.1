Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXFDMJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXFDMJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXFDMJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:09:00 -0400
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:58460 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXFDMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:09:00 -0400
Message-ID: <466400D7.8030204@tremplin-utc.net>
Date: Mon, 04 Jun 2007 14:08:55 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070423 Mandriva/2.0.0.0-1mdv2008.0 (2008.0) Thunderbird/2.0.0.0 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: jikos@jikos.cz, kernel list <linux-kernel@vger.kernel.org>,
       dtor@insightbb.com
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
References: <20070604112426.GA2707@elf.ucw.cz>
In-Reply-To: <20070604112426.GA2707@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

06/04/2007 01:24 PM, Pavel Machek wrote/a écrit:
> Hi!
> 
> I started getting blinking capslock leds in 2.6.22-somewhere. Every 5
> seconds or so, capslock led toggles on thinkpad x60. Ouch.
> 
Could it be related to commit f038f9a361a764ed013447174b7170073f89cbe9 
aka "Add keyboard blink driver" ? Probably you don't want it in hard in 
the kernel ;-)

See you,
Eric
