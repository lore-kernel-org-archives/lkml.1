Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbXGaLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbXGaLn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXGaLnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:43:18 -0400
Received: from compulypse.net ([212.227.20.180]:19227 "EHLO compulypse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXGaLnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:43:17 -0400
Subject: Re: [ck] Linux Kernel cfs scheduler and xorg kbd
From: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
To: CK Mailinglist <ck@vds.kolivas.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1185827130.26459.16.camel@xtower.fri>
References: <1185827130.26459.16.camel@xtower.fri>
Content-Type: text/plain; charset=utf-8
Date: Tue, 31 Jul 2007 13:42:59 +0200
Message-Id: <1185882179.26459.36.camel@xtower.fri>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

У пн, 2007-07-30 у 22:25 +0200, <::.. Teresa_II ..::> пише:


Ok, hier is small testing:
I started gcc emerge. System load is between 1.47 and 1.61
I use SMP enabled 2.6.22.1-cfs-v19.1 kernel on ADM64 X2.

In gnome-terminal window i just type fast "d" and until i count 1,2 i
hold SHIFT, than i release SHIFT, count 1,2 and than press SHIFT again.
I cound 1,2,1,2,1,2 as i type "d" button. That's the string i get:

DDDDDDDdDDDddDDddDDddDDDdDDDdDDDdDDDddDDddDDDdDDDddDDDdDDDdDDDDDDDdDDDDDDDDDDDdDDD

Its anyway different as expected.

I don't have better idea how to show what my problem is.

-- 
Teresa Kalitowska
jid: teresa@kvitka.net

