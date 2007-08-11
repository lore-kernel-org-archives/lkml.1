Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXHKPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXHKPxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXHKPxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 11:53:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45786 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXHKPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 11:53:11 -0400
Date: Sat, 11 Aug 2007 17:53:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
In-Reply-To: <20070810201235.GA4133@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0708111749540.3101@fbirervta.pbzchgretzou.qr>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
 <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de>
 <20070810074047.GC31307@uranus.ravnborg.org> <46BC6DA9.1050903@s5r6.in-berlin.de>
 <20070810201235.GA4133@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0708111750101.3101@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 10 2007 22:12, Sam Ravnborg wrote:
>Asciidoc is quite close to plaintext and it looks to me that the
>formatting possibilities are quite good.

How about mediwiki text?

'''Users'''
:are people who build kernels.

'''Normal developers'''
:are this and that....


>+=== Goal definitions
>+
>+Goal definitions are the main part (heart) of the kbuild Makefile.
>+These lines define the files to be built, any special compilation
>+options, and any subdirectories to be entered recursively.
>+
>+The most simple kbuild makefile contains one line:
>+
>+----
>+	obj-y += foo.o
>+----
>+This tells kbuild that there is one object in that directory, named
>+foo.o. foo.o will be built from foo.c or foo.S.

(wikitext continued)
The most simple kbuild makefile contains one line:

 obj-y += foo.o

This tells kbuild that...



	Jan
-- 
