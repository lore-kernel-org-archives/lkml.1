Return-Path: <linux-kernel-owner+w=401wt.eu-S1761916AbYAKRFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761916AbYAKRFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbYAKRE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:04:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39269 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753594AbYAKREz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:04:55 -0500
Date: Fri, 11 Jan 2008 17:01:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Filippos Papadopoulos" <psybases@gmail.com>
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org, "Chuck Ebbert" <cebbert@redhat.com>,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
Message-ID: <20080111170122.33b16e9a@lxorguk.ukuu.org.uk>
In-Reply-To: <9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	<9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	<476C1472.1040103@redhat.com>
	<1198271036.3130.60.camel@localhost.localdomain>
	<476C4177.3030902@redhat.com>
	<1198277391.3130.73.camel@localhost.localdomain>
	<9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	<1200028577.5337.8.camel@localhost.localdomain>
	<9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
	<1200066295.3286.19.camel@localhost.localdomain>
	<9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes it works under 2.6.16.13.  See the beginning of this thread, i
> mention there some things about newer versions.

It worked (ish.. it has problems and always has had) before the big
updates, and according to my tester after the big update + two patches
that escaped somewhere in the process. Unfortunately my tester no longer
has the card to dig further.

The 0x0 bug was fixed a while ago but seems to have sat in -mm for a bit.
Don't know about further stuff.
