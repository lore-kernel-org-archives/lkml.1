Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXEKT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXEKT3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXEKT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:29:13 -0400
Received: from gw.goop.org ([64.81.55.164]:34354 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbXEKT3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:29:12 -0400
Message-ID: <4644C401.5010208@goop.org>
Date: Fri, 11 May 2007 12:29:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
References: <20070406154628.GG12005@jukie.net> <m1zm4rd676.fsf@ebiederm.dsl.xmission.com> <20070429094135.GA10948@suse.de> <20070511182329.GJ4052@ucw.cz>
In-Reply-To: <20070511182329.GJ4052@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> I do not think OLPC is using linuxBIOS these days. What they have
> certainly looks like Sun's ROM monitor.

Yep, looks like they've got Mitch Bradley, (ex?) of Firmworks, doing
their firmware.  That means its pretty much exactly OpenFirmware.  Lots
of yummy, delicious Forth.

    J
