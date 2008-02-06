Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbYBFKHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbYBFKHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760848AbYBFKHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:07:07 -0500
Received: from twin.jikos.cz ([213.151.79.26]:49314 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760729AbYBFKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:07:06 -0500
Date: Wed, 6 Feb 2008 11:06:21 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Takashi Iwai <tiwai@suse.de>
cc: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>, Theodore Tso <tytso@MIT.EDU>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
In-Reply-To: <s5hfxw6tvaa.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.64.0802061105330.30873@twin.jikos.cz>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
 <20080204194038.d8851b8d.akpm@linux-foundation.org> <20080205113633.GI27738@hjernemadsen.org>
 <20080205102219.83fe459d.akpm@linux-foundation.org>
 <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com>
 <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz> <s5hfxw6tvaa.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Takashi Iwai wrote:

> > Takashi, if you need any other information which would help resolving 
> > this, please let me know.
> First, make sure that you unmuted the hardware volume / mute via laptop 
> keyboards. If everything looks OK ("PCM" adjusted, "Headphone" and 
> "Speaker" unmuted) but still it doesn't work, it can be a driver 
> problem. If you set CONFIG_SND_HDA_POWER_SAVE, try to undefine it.

Hmm, after flashing the newest BIOS update, everything seems to work now.

Felipe, that is probably your case too.

Thanks,

-- 
Jiri Kosina
