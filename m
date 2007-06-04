Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbXFDMgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbXFDMgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXFDMf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:35:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59816 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXFDMf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:35:58 -0400
Date: Mon, 4 Jun 2007 14:35:23 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, dtor@insightbb.com
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
In-Reply-To: <20070604112426.GA2707@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz>
References: <20070604112426.GA2707@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Pavel Machek wrote:

> I started getting blinking capslock leds in 2.6.22-somewhere. Every 5 
> seconds or so, capslock led toggles on thinkpad x60. Ouch. I also get 
> some stuck keys I was not getting before. I hope my userland did not go 
> crazy...

Hi Pavel,

what does

	grep BLINK .config

show?

-- 
Jiri Kosina
