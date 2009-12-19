Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZLSNQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZLSNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 08:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZLSNQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 08:16:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZLSNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 08:16:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Sat, 19 Dec 2009 13:16:38 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07503-g4027c0c-dirty; KDE/4.3.2; x86_64; ; )
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de> <200912171852.02906.arnd@arndb.de> <20091217111359.54f4c518@jbarnes-piketon>
In-Reply-To: <20091217111359.54f4c518@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912191316.38945.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/3IIlVQf6QWvf0hlDhlVdP/A4njR7CNyUUMhL
 1JobgUnwfkRsu4cj5qtmETvvl1QSBQ5gDfTVWQwWhL80mrxDgQ
 07m5evUlZy/chMkTALOyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 19:13:59 Jesse Barnes wrote:
> > Ok, I'll try that. The problem is keeping me from doing any useful
> > upstream kernel work on my main machine, so I'm rather motivated ;-)
> 
> Another patch to try...

Thanks!

It's running fine so far, uptime 90 minutes together with powersave=0.
I'll keep the machine running and tell you if it crashes again later.

	Arnd
