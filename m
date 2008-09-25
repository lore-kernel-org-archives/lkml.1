Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYIYUQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYIYUQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYIYUQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:16:38 -0400
Received: from brak.cowlabs.com ([208.96.51.45]:46715 "EHLO brak.cowlabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYIYUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:16:37 -0400
Date: Thu, 25 Sep 2008 13:16:27 -0700
From: carbonated beverage <ramune@net-ronin.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_ACPI_VIDEO on Thinkpad blanks display.
Message-ID: <20080925201627.GA19205@net-ronin.org>
References: <20080925060244.GA18945@net-ronin.org> <20080925070741.GA22376@net-ronin.org> <20080925100746.GA13185@srcf.ucam.org> <20080925190930.GA17184@net-ronin.org> <20080925195820.GD30858@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925195820.GD30858@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 04:58:20PM -0300, Henrique de Moraes Holschuh wrote:
> Well, we do give you a way out: do not load ACPI video, and load
> thinkpad-acpi with the proper parameters to enable its backlight control (if
> it is getting disabled by default).  Check the docs.

Thanks, I'll give this a shot.

> Your X is broken, and in an extremely hideous way.  You could try to get it
> to disable ACPI key support, or you can make sure nothing EVER sends ACPI
> video events to it.  That means you must not use the ACPI video module in
> your kernel until you install a fixed X.org.

Okay, I'll see what happens.

-- DN
Daniel
