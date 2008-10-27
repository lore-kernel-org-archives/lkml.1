Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYJ0V0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYJ0V0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYJ0V00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:26:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:65419 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYJ0V00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:26:26 -0400
Date: Mon, 27 Oct 2008 14:26:23 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@bogon.housecafe.de
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
Subject: Re: [software coproarchaeology] sbc8240 story
In-Reply-To: <20081026185647.GP28946@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0810271422240.7569@bogon.housecafe.de>
References: <20081026185647.GP28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1169 2008-08-27)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX1+uCtWIZy2h2IcurUgAHPQsOJSjAcE6vwr7CuA
 hx+cZCcbGhvREIp9d3ts201wJg45Hkq54nDUibPM6niF9ME4Qd
 lX/zU1vgY0FI1AXBMdNIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Al Viro wrote:
> As an aside, this story says a lot about our build coverage.  And probably
> quite a few sad things about development process...

For the record: the driver depends on MTD_JEDECPROBE && 8260, where 8260 
is filed under "82xx-based boards" in PowerPC. I don't know if we have 
that much compile tests for this particular arch. http://l4x.org "only" 
lists cell_defconfig and g5_defconfig...

C.
-- 
BOFH excuse #167:

excessive collisions & not enough packet ambulances
