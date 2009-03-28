Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZC1QZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZC1QZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZC1QZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:25:22 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:55916 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZC1QZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UAa18P/Bn4MtFrCEfYHcjwPM9A4yuPTI1lgkMx4RUkO2ZEA2NyBVIcIWrs3KXtEY7e
         9gMkUry6w+KxOYYVu7nS2NAB34I9o6H3XdZWIfOcMBCFwNMLauju9PDBjDR/TiQeFsRq
         0uWh8Hc1K5lYRy2eNXYcgveKc82Jnpm20Cr/I=
MIME-Version: 1.0
In-Reply-To: <49CE35AE.1080702@s5r6.in-berlin.de>
References: <20090327051338.GP6239@mit.edu> <49CD4DDF.3000001@garzik.org>
	 <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
Date: Sat, 28 Mar 2009 09:25:17 -0700
Message-ID: <faa09fad0903280925t35a61c0aj2ae29d90337b9dab@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Alex Goebel <alex.goebel@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <lkml@rtr.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/09, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Well, for the time being, why not base considerations for performance,
> interactivity, energy consumption, graceful restoration of application
> state etc. on the assumption that kernel crashes are suitably rare?  (At
> least on systems where data loss would be of concern.)

Absolutely! That's what I thought all the time when following this
(meanwhile quite grotesque) discussion. Even for ordinary
home/office/laptop/desktop users (!=kernel developers), kernel crashes
are simply not a realistic scenario any more to optimize anything for
(which is due to the good work you guys are doing in making/keeping
the kernel stable).

Alex
