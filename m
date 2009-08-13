Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZHMIm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZHMIm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZHMIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:42:58 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38193 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZHMIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:42:58 -0400
Date: Thu, 13 Aug 2009 10:42:57 +0200
From: Andreas Mohr <andi@lisas.de>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: CPU scheduler weirdness?
Message-ID: <20090813084257.GA761@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0908130218180.8987@cinke.fazekas.hu>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does anybody have any idea what can cause this?

/sys/devices/system/cpu/sched_smt_power_savings , perhaps?

Andreas Mohr
