Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYKKP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYKKP1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYKKP1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:27:40 -0500
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:60547 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbYKKP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:27:39 -0500
Date: Tue, 11 Nov 2008 16:27:36 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081111152736.GA28569@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081110094239.GA14204@atrey.karlin.mff.cuni.cz> <20081110221343.GA17951@mobydick> <200811101506.53324.jbarnes@virtuousgeek.org> <20081110231524.GA18971@mobydick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110231524.GA18971@mobydick>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 12:15:24AM +0100, Mathieu Chouquet-Stringer wrote:
> This one I guess:
> http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view
> 
> Let me give it a shot, I'll keep you posted.

So I compiled the module, rebooted just to have a clean starting point,
started X then tried to suspend: no go...
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
