Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZLNEEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZLNEEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZLNEEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:04:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:58536 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbZLNEEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:04:42 -0500
Subject: Re: [git pull] drm nouveau pony for Xmas.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1260761747.2217.13.camel@pasglop>
References: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912111516550.3526@localhost.localdomain>
	 <1260761747.2217.13.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 15:03:18 +1100
Message-ID: <1260763398.2217.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 14:35 +1100, Benjamin Herrenschmidt wrote:

> And built-in works beautifully with kms & fbdev on top of it etc...
> (real fast console switches ! yay !) if I do
> 
> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
> CONFIG_EXTRA_FIRMWARE="/nouveau/xxx.ctxprog nouveau/yyy.ctxvals"
                         ^
                      Without that "/" of course :-)

Cheers,
Ben.


