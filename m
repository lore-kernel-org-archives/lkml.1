Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYKMMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYKMMz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKMMzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:55:46 -0500
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:35884 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYKMMzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:55:45 -0500
Date: Thu, 13 Nov 2008 13:55:42 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081113125542.GA27169@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081110231524.GA18971@mobydick> <20081111152736.GA28569@mobydick> <200811121033.58840.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811121033.58840.jbarnes@virtuousgeek.org>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

On Wed, Nov 12, 2008 at 10:33:58AM -0800, Jesse Barnes wrote:
> Dave pushed a fix for this (more complete than the one in the patch you 
> reference), have you tried the kernel from today to see if things work now?

Just did (2.6.28-rc4-00305-g4ffaf86) and it works for me.

Thanks!

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
