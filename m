Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861Ab0AYFQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0AYFQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 00:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589Ab0AYFQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 00:16:54 -0500
Received: from web55003.mail.re4.yahoo.com ([206.190.58.137]:25272 "HELO
	web55003.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750824Ab0AYFQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 00:16:53 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 00:16:53 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=ul2z76rFYQ6Cdq3wDgDHT59MNDECP9ch/4unsHdCqn9DyjyeZEbNLSKgpRrP4oBRY8Fu4zbnKV+G+N+G3lYE6B3OITWq+veuE+31I+SZwJ431Ogo+zb/rK0MCGroEwcqVC+ivyXoB67yZK5WY/ip5ERR6XAYpvspdJPWoBXqJnQ=;
Message-ID: <8364.43349.qm@web55003.mail.re4.yahoo.com>
X-YMail-OSG: dRVU2XgVM1mT.rGc74yb0N8l4Fk6T22gJeSH8X3Q2s2eTz._3C06OZ6Y.Mr2nNeNCVSASjdAKmT8etH._tX4wCaFclD39kpmfUwEnw4SelfTqlWsSxmA2_TGSlqk_J1RNJdhRkn_7rkDbJvmoJUHyEdaC_Dgsk2J0srFOi2XAD6UmTdO3H_bRWf2b8Vgm3Dj2yJ0JEFHyoYI71xZFPezOHPZuKDojUfo7XiCfIODi2F1SigV01pjpqY6DTZUH5B49aKvgcbwQL0-
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Sun, 24 Jan 2010 21:10:10 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get to performance counters
To: linux-kernel@vger.kernel.org
Cc: arjan@infradead.org, mingo@elte.hu, peterz@infradead.org,
       fweisbec@gmail.com, whalajam@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

> This patch adds the needed bits to do enable this functionality; they have been
> tested in an experimental cpufreq driver that I'm working on, and the changes
> are all that I needed to access counters properly.

Very useful for a driver performance analysis.
It doesn't look like you added the new api's to your cpufreq driver yet, can you please provide an example of their usage, possibly monitoring multiple counters concurrently?

John


      
