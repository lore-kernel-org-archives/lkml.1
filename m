Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526Ab0AKDd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0AKDd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 22:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879Ab0AKDd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 22:33:57 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:58378 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750834Ab0AKDd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 22:33:57 -0500
Message-ID: <4B4A9C27.4060807@snapgear.com>
Date: Mon, 11 Jan 2010 13:33:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] error message when FLAT reloc symbol is
 invalid, v2
References: <20100101012852.GC16887@Pogoplug>
In-Reply-To: <20100101012852.GC16887@Pogoplug>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jun,

Jun Sun wrote:
> See the attachement.

That looks good. I'll apply to the m68knommu git tree and push to
Linus in the next merge window (for 2.6.34).

Regards
Greg


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
