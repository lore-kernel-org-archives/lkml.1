Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0BSGjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:39:39 -0500
Received: from eazy.amigager.de ([213.239.192.238]:57218 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0BSGjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:39:36 -0500
Date: Fri, 19 Feb 2010 07:39:29 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pedro Ribeiro <pedrib@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] i915 / PM: Fix hibernate regression caused by
 suspend/resume splitting
Message-ID: <20100219063929.GA2851@x61.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pedro Ribeiro <pedrib@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
 <201002172320.57491.rjw@sisk.pl>
 <74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com>
 <201002182306.28052.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002182306.28052.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 23:06:27 +0100, Rafael J. Wysocki wrote:

[...]

> Jesse, Eric, the appended patch fixes a very recent hibernate regression in
> i915, please push it to Linus ASAP.

FYI: I got no resume failure during normal usage after 9 suspend to RAM
and 8 suspend to disk cycles (using both suspend types alternately)
with the patch applied.

Regards,
Tino
