Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYLUOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYLUOlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYLUOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:41:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58834 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751869AbYLUOlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:41:09 -0500
Date: Sun, 21 Dec 2008 14:41:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dz@debian.org,
       "Federico Heinz" <fheinz@vialibre.org.ar>,
       "Andy Spencer" <spenceal@rose-hulman.edu>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS
 version with force=1
Message-ID: <20081221144109.2ed26cf2@lxorguk.ukuu.org.uk>
In-Reply-To: <76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
	<76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
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

On Wed, 17 Dec 2008 20:07:02 -0500
"Andrew Paprocki" <andrew@ishiboo.com> wrote:

> On Wed, Dec 17, 2008 at 7:34 PM, Andrew Paprocki <andrew@ishiboo.com> wrote:
> > I see two problems with the i8k module and the Dell XPS M1530. First,
> > the laptop is not detected. Second, even if it is detected, the module
> > prints that it is unable to get the SMM BIOS version even though the
> > module appears to be working:
> 
> It appears that the Dell Vostro & Precision series have the same issue
> and the driver was never updated for those as well. Patches were
> submitted back in 2007-11 and 2008-04 respectively:
> 
> http://marc.info/?l=linux-kernel&m=119401935026583&w=2
> http://marc.info/?l=linux-kernel&m=120822526223412&w=2

I can find no copies of them with Signed-off-by: lines so they appear to
have escaped. If the authors of those changes would care to provided
Signed-off-by: lines I'll chase this up further.
