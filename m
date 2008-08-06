Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbYHFMEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbYHFMEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYHFMEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:04:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18730 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYHFMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:04:23 -0400
Date: Wed, 6 Aug 2008 13:15:54 +0200
From: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [GIT PATCH] hwmon updates against v2.6.26
Message-ID: <20080806131554.4b113c5e@hyperion.delvare>
In-Reply-To: <20080806103903.6b9eec76@hyperion.delvare>
References: <20080801041026.GI3375@mars.solarsys.private>
	<20080806103903.6b9eec76@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 10:39:03 +0200, Jean Delvare wrote:
> I have a number of hwmon patches in my local kernel tree which I wrote
> and that have been reviewed by a trusted developer, or that have been
> posted to the lm-sensors list and that I have reviewed. I consider
> these ready to go upstream. I plan to gather these into a public tree
> and push them to Linus today or tomorrow. In the future, I will
> probably have such a tree available to be included in linux-next.

The patches in question are here if anyone wants to take a look:
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-hwmon/

I'll make a git branch out of them by the end of the day, for Linus to
pull from.

-- 
Jean Delvare
