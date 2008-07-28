Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbYG1QfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbYG1QfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYG1Qez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:34:55 -0400
Received: from mail119.messagelabs.com ([216.82.245.51]:54906 "HELO
	mail119.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750870AbYG1Qey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:34:54 -0400
X-VirusChecked: Checked
X-Env-Sender: ziomek@labs.mot.com
X-Msg-Ref: server-4.tower-119.messagelabs.com!1217262892!29823782!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [129.188.136.8]
Date: Mon, 28 Jul 2008 11:34:35 -0500
From: T Ziomek <ctz001@email.mot.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Milton Miller <miltonm@bga.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
Message-ID: <20080728163435.GE27068@email.mot.com>
References: <1216887460.306306.238738123378.1.gpush@pingu> <200807250108.m6P18f4B099179@sullivan.realtime.net> <fa686aa40807252155l4f785920qdb14d117067b30f4@mail.gmail.com> <913573e2092839fbe37a0bfa37119eb6@bga.com> <fa686aa40807261053r5a8ebe40l7e8061f926f185f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40807261053r5a8ebe40l7e8061f926f185f9@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 01:53:57PM -0400, Grant Likely wrote:
 . . .
> Come to think of it, I'd support just removing the zImage symlink
> entirely to eliminate confusion so that everyone knows that 'make
> zImage' is the 'make all' for default image targets.

That ("zImage" means all default image targets) seems pretty non-intui-
tive; why not something like 'make all_def_images'?

Tom
-- 
  /"\  ASCII Ribbon Campaign   |
  \ /                          |   Email to user 'CTZ001'
   X        Against HTML       |             at 'email.mot.com'
  / \     in e-mail & news     |
