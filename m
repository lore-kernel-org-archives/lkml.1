Return-Path: <linux-kernel-owner+w=401wt.eu-S1764037AbXGPLXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764037AbXGPLXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXGPLXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:23:24 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:37337 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754058AbXGPLXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:23:24 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 07:23:23 EDT
Date: Mon, 16 Jul 2007 12:59:42 +0200
From: Martin Mares <mj@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [x86 setup 27/33] Video mode probing support for the new x86 setup code
Message-ID: <mj+md-20070716.105920.26230.nikam@ucw.cz>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com> <509992ad2f618e07db2c72a96f8f5d708bfc6991.1184181208.git.hpa@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509992ad2f618e07db2c72a96f8f5d708bfc6991.1184181208.git.hpa@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Video mode probing for the new x86 setup code.  This code breaks down
> different drivers into modules.  This code deliberately drops support
> for a lot of the vendor-specific mode probing present in the assembly
> version, since a lot of those probes have been found to be stale in
> current versions of those chips -- frequently, support for those modes
> have been dropped from recent video BIOSes due to space constraints,
> but the video BIOS signatures are still the same.

Acked-By: Martin Mares <mj@ucw.cz>

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
"It's a lemon tree, my dear Watson." -- Sherlock Holmes (?)
