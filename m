Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXEWH6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXEWH6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXEWH6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:58:46 -0400
Received: from smtp21.orange.fr ([80.12.242.47]:44420 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXEWH6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:58:45 -0400
X-ME-UUID: 20070523075843375.5BB301C000D5@mwinf2112.orange.fr
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
From: Xavier Bestel <xavier.bestel@free.fr>
To: Michael Gerdau <mgd@technosis.de>
Cc: Con Kolivas <kernel@kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       Miguel Figueiredo <elmig@debianpt.org>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <200705230723.42400.mgd@technosis.de>
References: <464F57DD.2000309@tmr.com> <46538AB8.8030009@tmr.com>
	 <200705241036.45179.kernel@kolivas.org>
	 <200705230723.42400.mgd@technosis.de>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:58:35 +0200
Message-Id: <1179907115.7699.271.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 07:23 +0200, Michael Gerdau wrote:
> For me the huge difference you have for sd to the others increases the
> likelyhood the glxgears benchmark does not measure scheduling of graphic
> but something else.

I think some people forget that X11 has its own scheduler for graphics
operations.

	Xav


