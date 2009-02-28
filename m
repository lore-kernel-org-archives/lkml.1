Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZB1Sqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZB1Sqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZB1Sq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:46:28 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:35091 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZB1Sq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:46:27 -0500
Date: Sat, 28 Feb 2009 19:51:43 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Risto Suominen <risto.suominen@gmail.com>
Cc: adaplas@pol.net, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
Message-Id: <20090228195143.03b1f600.krzysztof.h1@poczta.fm>
In-Reply-To: <46e1c7760902222253p34a714bao5c06b0ad4d779337@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	<46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	<46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	<46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	<20090211142409.b88c577e.akpm@linux-foundation.org>
	<46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
	<20090213210635.d094ffc8.krzysztof.h1@poczta.fm>
	<20090222081517.567a29bd.krzysztof.h1@poczta.fm>
	<46e1c7760902220125l61700421gc4045ca10ea4dd10@mail.gmail.com>
	<20090222164052.dd5442c4.krzysztof.h1@poczta.fm>
	<46e1c7760902222253p34a714bao5c06b0ad4d779337@mail.gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 44e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Risto,

I ahve checked xorg server 1.1.1 with kernel 2.6.24
 and I cannot reproduce your problem (hw cursor
left in Xfbdev) with two drivers using the hw cursor
(pm2fb and tdfxfb). Tests were done on x86 (amd 
k6-2+ cpu).

Regards,
Krzysztof

----------------------------------------------------------------------
Dzien Kobiet dniem wolnym od pracy? Wypowiedz sie i wygraj nagrode! 
Sprawdz >> http://link.interia.pl/f2076 

