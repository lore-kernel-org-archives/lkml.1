Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZJ3Akz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZJ3Akz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZJ3Aky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:40:54 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:43862 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbZJ3Akx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:40:53 -0400
Message-ID: <4AEA3602.1060105@snapgear.com>
Date: Fri, 30 Oct 2009 10:40:34 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>
CC: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] Coldfire GPIO corrections
References: <200910151254.41599.sfking@fdwdc.com>
In-Reply-To: <200910151254.41599.sfking@fdwdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven King wrote:
> Pin 0 of the EPORT is not connected on the 523x, 5271, 5275 and 528x and the 
> TIMER on the 523x has 8 pins, not 4.

Thanks, I have pushed this into the for-linus branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
