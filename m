Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYLFF0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYLFF0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 00:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLFFZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 00:25:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:52362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYLFFZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 00:25:56 -0500
Message-ID: <493A0C7C.3020608@kernel.org>
Date: Sat, 06 Dec 2008 14:24:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Jake Edge <jake@lwn.net>, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 067/104] libata: improve phantom device	detection
References: <20081203193901.715896543@mini.kroah.org> <20081203195323.GP8950@kroah.com> <49375A7F.10407@kernel.org> <20081205183657.GC2144@kroah.com>
In-Reply-To: <20081205183657.GC2144@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Dec 2008 05:23:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ok, I'll transfer it over to the next 2.6.27-stable release.

Thanks.

-- 
tejun
