Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZA0NiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZA0NiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZA0NiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:38:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49871 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753039AbZA0NiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:38:13 -0500
Date: Tue, 27 Jan 2009 13:37:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thierry Vignaud <tvignaud@mandriva.com>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
       Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?us-ascii?B?TU9LUkVK?= =?us-ascii?B?X18=?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090127133732.0d54f430@lxorguk.ukuu.org.uk>
In-Reply-To: <m2vds0vq44.fsf@vador.mandriva.com>
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no>
	<20090104224052.GE1913@elf.ucw.cz>
	<20090104233052.GG22958@mit.edu>
	<200901042149.27655.rob@landley.net>
	<20090105111913.47a8d1a5@lxorguk.ukuu.org.uk>
	<m2vds0vq44.fsf@vador.mandriva.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I remember seeing I/O error on CDs resulting in zillions of retries on
> errors on USB discs resulting in resetting the USB port again & again
> for hours... (CD case is years ago, but I usually see the USB layer
> trying reseting for quite a long time at least once per month)

Most of the CD ones are caused by tools like hal continuing to probe the
device regularly and causing new avalanches of errors.
