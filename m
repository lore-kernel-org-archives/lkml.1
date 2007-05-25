Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbXEYTn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbXEYTn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXEYTnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:43:22 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45514 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752090AbXEYTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:43:22 -0400
Date: Fri, 25 May 2007 21:43:21 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Olaf Hering <olaf@aepfle.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
In-Reply-To: <20070525114550.GA32552@aepfle.de>
Message-ID: <Pine.LNX.4.62.0705252143070.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.575306000@sonycom.com>
 <20070525114550.GA32552@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Olaf Hering wrote:
> On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:
> > Add a Disk Storage Driver for the PS3:
> 
> There is no device symlink in /sys/block/ps3da/

Interesting... Do you know how to create it?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
