Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbZLPVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbZLPVgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbZLPVgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:36:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbZLPVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:36:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Wed, 16 Dec 2009 21:36:36 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07500-g8bea867-dirty; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <200912162120.34163.arnd@arndb.de> <20091216133005.0e822950@jbarnes-piketon>
In-Reply-To: <20091216133005.0e822950@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162136.36458.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18nzZ19DA/4AP7VcgNUqQkN/RN8t/eykmsNCXg
 hzHnAozXRUAKhfMaFHpVdMxJ7p7WXFJ8zyuVaBmYoHCou7s5dV
 VPYPz/GzQvmIFKka9TQTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009 21:30:05 Jesse Barnes wrote:
> But you're sure powersave=0 was solid?  Hmm...

It's hard to be sure when it sometimes takes a day before a
broken version crashes. I can keep running this kernel with and
without powersave=0 some more and tell you if it stays reproducible.

	Arnd
