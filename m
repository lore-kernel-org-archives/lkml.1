Return-Path: <linux-kernel-owner+w=401wt.eu-S1030360AbXDCXtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360AbXDCXtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXDCXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:49:15 -0400
Received: from smtpa1.netcabo.pt ([212.113.174.16]:19269 "EHLO
	exch01smtp03.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030275AbXDCXtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:49:14 -0400
Message-ID: <4612E803.8070600@rncbc.org>
Date: Wed, 04 Apr 2007 00:49:23 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: 2.6.21-rc5-rt10 troubles
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
In-Reply-To: <20070401183928.GB27614@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 23:49:11.0309 (UTC) FILETIME=[AD745BD0:01C7764A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo et al.

I'm afraid having no good news (once again). After building
2.6.21-rc5-rt8 and recently on -rt10 I've found some trouble running on
a Core2 T7200 laptop (SMP). Somehow, specially after starting jackd, the
whole system starts crawling to death. It just slows down to some kind
of Big Freeze, with no evidence over the console whatsoever, so that I'm
ultimately left with a brick on my hands.

This behavior is consistent and occurs every time after jackd is
started. It does not seem to occur on -rt5 and earlier.

I wish I could give you more details, but fact is I don't know where to
look. The machine just freezes silently.

Bye now.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org

