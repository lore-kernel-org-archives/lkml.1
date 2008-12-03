Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYLCXTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYLCXTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYLCXTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:19:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYLCXTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:19:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [patch 000/104] 2.6.27-stable review
Date: Thu, 4 Dec 2008 00:18:19 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20081203194725.GA8950@kroah.com> <200812032239.14280.rjw@sisk.pl> <493703E2.7000305@msgid.tls.msk.ru>
In-Reply-To: <493703E2.7000305@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040018.20992.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Michael Tokarev wrote:
> Rafael J. Wysocki wrote:
> []
> > The following ACPI commits are also -stable material IMO:
> 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b4d469228a92a00e412675817cedd60133de38a
> This is
>  [patch 062/104]
>    ACPI: EC: count interrupts only if called from interrupt handler.

Thanks a lot, I overlooked it.

Rafael
