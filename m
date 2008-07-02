Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYGBPJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYGBPJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYGBPJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:09:11 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:53831 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754689AbYGBPJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:09:10 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/9] TTY: fix for tty operations bugs
Date: Wed, 2 Jul 2008 18:09:05 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de>
In-Reply-To: <20080702144149.GA16850@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807021809.07679.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

02 Tem 2008 Çar tarihinde, Greg KH şunları yazmıştı: 
> Are you sure you redid your patch set, I see fixes for the error
> messages above in that patch I did.  I also don't get the build problems
> myself anymore.

I start to hate myself :(, as you said refreshing whole patchset with quilt solved the compiliation problem, i thought i did refresh but i didn't, and compiled kernel works fine. I really have to drink some coffee.

> confused,

Sorry for your time...

> greg k-h

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
