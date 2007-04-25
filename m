Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXDYOFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXDYOFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXDYOFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:05:43 -0400
Received: from gw.goop.org ([64.81.55.164]:51353 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXDYOFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:05:42 -0400
Message-ID: <462F604C.8050308@goop.org>
Date: Wed, 25 Apr 2007 07:06:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org> <20070425113102.GU3468@stusta.de> <20070425130102.GA10141@redhat.com>
In-Reply-To: <20070425130102.GA10141@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> I think this was due to Jeremy not having CONFIG_FB_BACKLIGHT=y in his config.
>   

No, I enabled it and it still works.

    J

