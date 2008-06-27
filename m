Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYF0Nco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYF0Nco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYF0Nce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:32:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49935 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYF0Nce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:32:34 -0400
Date: Fri, 27 Jun 2008 15:32:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Pavel Machek <pavel@suse.cz>
cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
In-Reply-To: <20080626201754.GE9878@ucw.cz>
Message-ID: <alpine.LNX.1.10.0806271532150.12725@fbirervta.pbzchgretzou.qr>
References: <48634BA7.6030902@slax.org> <20080626201754.GE9878@ucw.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-06-26 22:17, Pavel Machek wrote:
>> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)
>
>You need some good reason why lzma should be in kernel... like 'cramfs
>can use it'...?

squashfs if at all.
