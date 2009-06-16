Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZFPNcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZFPNcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZFPNcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:32:06 -0400
Received: from tichy.grunau.be ([85.131.189.73]:43368 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZFPNcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:32:05 -0400
Date: Tue, 16 Jun 2009 15:33:11 +0200
From: Janne Grunau <j@jannau.net>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] eeepc-laptop: add 3G rfkill support for 901Go
Message-ID: <20090616133311.GB8052@aniel.lan>
References: <20090612223255.GD14878@aniel.lan> <71cd59b00906122352g77e8afdeh235c2a73b323a0d7@mail.gmail.com> <20090613110627.GG14878@aniel.lan> <71cd59b00906130436i5024afa7q5b7cb40005014e14@mail.gmail.com> <71cd59b00906150448k64ae335ah597e194180048c46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71cd59b00906150448k64ae335ah597e194180048c46@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:48:03PM +0200, Corentin Chary wrote:
> 
> You can find the patch here,
> http://git.iksaif.net/?p=acpi4asus.git;a=shortlog;h=refs/heads/eeepc-laptop

Thanks, rfkill for the 3g modem works as expected. But the wlan hotkey
Fn + F1 doesn't work. I haven't had time to look at it.

Janne
