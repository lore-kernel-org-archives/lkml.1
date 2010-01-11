Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979Ab0AKTlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0AKTlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300Ab0AKTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:41:09 -0500
Received: from 49.119.116-78.rev.gaoland.net ([78.116.119.49]:52223 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751087Ab0AKTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:41:08 -0500
X-Greylist: delayed 70783 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 14:41:06 EST
Date: Mon, 11 Jan 2010 01:01:15 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Vlad Dascalu <vlad.dascalu@goobix.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: r8169 - Serios Regression (was Re: r8169 linux driver)
Message-ID: <20100111000115.GB8959@electric-eye.fr.zoreil.com>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>,
	Vlad Dascalu <vlad.dascalu@goobix.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <a16d8c9b1001101351y1783157r327761bd2c86def1@mail.gmail.com>
 <a16d8c9b1001101355x72565562k7c16e5acca243fe4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a16d8c9b1001101355x72565562k7c16e5acca243fe4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 10:55:23PM +0100, Vlad Dascalu wrote:
[...]
> There are lots of reports and stack dumps at
> https://bugzilla.redhat.com/show_bug.cgi?id=538920.

Mmmm... Mixing different network cards.

> It seems it's mainly a communication issue to get those dumps on
> lkml where people can look at it.

I'll take a look tomorrow. A complete dmesg from boot to bug would be
welcome.

-- 
Ueimor
