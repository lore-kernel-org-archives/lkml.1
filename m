Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbZFMLFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbZFMLFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZFMLFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:05:24 -0400
Received: from tichy.grunau.be ([85.131.189.73]:33914 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZFMLFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:05:23 -0400
Date: Sat, 13 Jun 2009 13:06:27 +0200
From: Janne Grunau <j@jannau.net>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] eeepc-laptop: add 3G rfkill support for 901Go
Message-ID: <20090613110627.GG14878@aniel.lan>
References: <20090612223255.GD14878@aniel.lan> <71cd59b00906122352g77e8afdeh235c2a73b323a0d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71cd59b00906122352g77e8afdeh235c2a73b323a0d7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 08:52:17AM +0200, Corentin Chary wrote:
> First,
> Could you fill http://dev.iksaif.net/projects/acpi4asus/wiki/CMSG with
> your model CMSG ?

done, I suspect there's an error for the 701 and 901 in that table.
CM_ASL_CARDREADER should be 1 instead of CM_ASL_MODEM.
http://wiki.debian.org/DebianEeePC/Models supports that.

Do you plan to update eeepc-laptop with all CM_ASL bits?

> Then, I was working on a patch to refactor rfkill code in
> eeepc-laptop. With this patch, adding 3g rfkill
> is only 15-20 lines.

good, I was too lazy to refactor it.

> I'll add it to acpi4asus git tree soon.
> From here:
>  - I can rework your patch
> - you can re-send it when rfkill refactoring is here.
> 
> as you want =).

Drop me a mail when you're done but doesn't really matter who does it.

Janne
