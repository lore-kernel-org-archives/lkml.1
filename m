Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYLINQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYLINQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYLINQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:16:11 -0500
Received: from smtp.nokia.com ([192.100.105.134]:29892 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYLINQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:16:09 -0500
Date: Tue, 9 Dec 2008 15:17:05 +0200
From: Lauri Leukkunen <lauri.leukkunen@nokia.com>
To: ext Sam Ravnborg <sam@ravnborg.org>
Cc: Trilok Soni <soni.trilok@gmail.com>, David Brownell <david-b@pacbell.net>,
       dmitry.torokhov@gmail.com,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Add TI TSC2005 Touchscreen driver
Message-ID: <20081209131705.GC6667@pure.research.nokia.com>
References: <5d5443650812080949h5aff6010mb7341f581841f126@mail.gmail.com> <20081208182648.GA9740@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208182648.GA9740@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 09 Dec 2008 13:15:35.0621 (UTC) FILETIME=[38CCB750:01C95A00]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/08 19:26 +0100, ext Sam Ravnborg wrote:
> > Add Texas Instruments TSC2005 chip touchscreen driver.
> > 
> > Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
> 
> Hi Trilok.
> A few nitpicks below.
> 
> In general a very clean written driver with adequate comments - nice work!

Umm, isn't this code mostly written by Nokia? At least I remember modifying
some of it, and this version looks like Konsta Karsisto might be the last
person touching it. Originally I think it's written by Imre Deak, probably
based on the tsc2301 code.

/lauri

