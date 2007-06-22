Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXFVIfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXFVIfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXFVIfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:35:10 -0400
Received: from ns.firmix.at ([62.141.48.66]:36325 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbXFVIfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:35:07 -0400
Subject: Re: Please release a stable kernel Linux 3.0
From: Bernd Petrovitsch <bernd@firmix.at>
To: =?ISO-8859-1?Q?Zolt=E1n?= HUBERT <zoltan.hubert@zzaero.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706220057.33984.zoltan.hubert@zzaero.com>
References: <200706212349.54983.zoltan.hubert@zzaero.com>
	 <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com>
	 <200706220057.33984.zoltan.hubert@zzaero.com>
Content-Type: text/plain; charset=utf-8
Organization: Firmix Software GmbH
Date: Fri, 22 Jun 2007 10:34:56 +0200
Message-Id: <1182501296.27891.7.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.095 () AWL
X-Firmix-Spam-Status: No, hits=-1.095 required=5
X-Spam-Score: -1.095 () AWL
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 00:57 +0200, Zoltán HUBERT wrote:
[...]
> Well, I'm using SuSE Pro 9.3 (excellent choice by the way), 

Perhaps in April 2005. And if I read
http://www.pro-linux.de/security/7043 correctly it is unsupported
anyways (sorry, I can't find a date on that page).
ATM there are probably newer releases and I doubt that there are no
updates for the kernel (even Debian/Stable has them).

> coming with kernel 2.6.10-SuSE, on a ATI laptop, and the 
> drivers privided wouldn't compile (suspend & freinds). The 
> SATA disks were only supported from 2.6.15 (which just came 
> out), so I had to edit the "source code" of a closed source 
> driver to make it all work well. If that's "easy" for you I 
> doubt it is for 99.999% of earth's population. "World 
> domination" is far away.

That's an unsolvable problem: You want a "stable" distribution from year
X to support hardware designed and built in the future.

And BTW perhaps it is enough to take the kernel RPM (+ plus a few of the
kernel-near ones - dependencies will probably tell you) from the most
recent SuSE and try that if you for whatever reason want to stay with
the above release.

[...]

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


