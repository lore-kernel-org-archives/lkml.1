Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZGLV1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZGLV1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZGLV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:27:30 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:63688 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZGLV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:27:30 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 17:27:29 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=d5QSMLHP1AqXMLCEYgFMjzDhs0lDsf66gf88+CeYliOXbgyGkLOXmh7tImOejUkkPK
         qCjHssFR60ukLEBTMtq4ZqFv1u0ofJSyezDNcbevYHwRvR/aEYkY37yEWl9EI8WHSt2u
         qUKx0TUzD3UEsWec/Btqpt1cRrriMjp+KdMWc=
Date: Sun, 12 Jul 2009 17:19:50 -0400
From: Celejar <celejar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: suspend to disk now broken
Message-Id: <20090712171950.4d493cac.celejar@gmail.com>
In-Reply-To: <200907122256.01663.rjw@sisk.pl>
References: <20090712151947.25446ceb.celejar@gmail.com>
	<200907122219.53116.rjw@sisk.pl>
	<20090712162635.0e451001.celejar@gmail.com>
	<200907122256.01663.rjw@sisk.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 22:56:01 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 12 July 2009, Celejar wrote:
> > On Sun, 12 Jul 2009 22:19:52 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday 12 July 2009, Celejar wrote:
> > > > Hi,
> > > > 
> > > > A recent change to the kernel has apparently broken suspend to disk on
> > > > my machine.  It still works fine in 2.6.30.1, but hangs during the
> > > > 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the

...

> Please try to boot with init=/bin/bash and use the 'echo ...' method.

Still fails, as before.

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

