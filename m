Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYHNApn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYHNApn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYHNApg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:45:36 -0400
Received: from gw.goop.org ([64.81.55.164]:46466 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbYHNApf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:45:35 -0400
Message-ID: <48A38013.5020307@goop.org>
Date: Wed, 13 Aug 2008 17:45:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: thinkpad x60 is cooled passively
References: <20080813080618.GA16061@elf.ucw.cz> <20080813152431.GD8232@mit.edu> <20080813203137.GB27546@khazad-dum.debian.net>
In-Reply-To: <20080813203137.GB27546@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> ThinkPad fans have a overdesign range of about 2x, they almost never stop
> because they're too old.  Clogged in dirt, on the other hand... a clogged
> fan often spins FASTER and cools less.
>
> Want to see how much your fan has as far as a safety margin goes? use
> thinkpad-acpi to measure RPMs in level 7 and also when you switch PWM off
> (i.e. set it to 100% duty cycle).  Mine gets faster by 1500RPM or so that
> reflects the extra torque the EC can apply to get the fan to run at the
> speed it wants it to.
>
> But the thermal sink interface to the CPU and GPU are sometimes crap [when
> compared with the quality of the rest of the machine].  Open it, remove the
> crap, and replace it with a very high quality compound.  Dependin on
> ThinkPad model, you also need to repair thermal sink design defects to make
> it fit properly (read: press really tightly) on all chips.

Yes, this seems like a widespread and chronic problem with these little 
Thinkpads.  I've had both an X31 and X60 go bad this way, and a friend 
has had his X60 fail twice.  A pity given how nice the rest of the 
machine is.

    J

