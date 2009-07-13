Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZGMCHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZGMCHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZGMCH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:07:29 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:43177 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZGMCH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=MacRiOjsX/EFnVFRdn9MdAlU802g7f5F0ZwLPwp+kGIKhdJaMHaFADhHgGpAQ+1set
         8ipg5tJiq7rujKu1R0RiQ0++v9lhUmukpogSgl8NEMk680IlXyXeHtyp5bIjT5CFcS4w
         4+KtscD8U2Qr21O6g8am1EG5hCo7tlPLHPoQk=
Date: Sun, 12 Jul 2009 22:07:21 -0400
From: Celejar <celejar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: suspend to disk now broken
Message-Id: <20090712220721.ff14e2fe.celejar@gmail.com>
In-Reply-To: <200907130339.35003.rjw@sisk.pl>
References: <20090712151947.25446ceb.celejar@gmail.com>
	<200907122256.01663.rjw@sisk.pl>
	<20090712171950.4d493cac.celejar@gmail.com>
	<200907130339.35003.rjw@sisk.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 03:39:34 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 12 July 2009, Celejar wrote:
> > On Sun, 12 Jul 2009 22:56:01 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday 12 July 2009, Celejar wrote:
> > > > On Sun, 12 Jul 2009 22:19:52 +0200
> > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > 
> > > > > On Sunday 12 July 2009, Celejar wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > A recent change to the kernel has apparently broken suspend to disk on
> > > > > > my machine.  It still works fine in 2.6.30.1, but hangs during the
> > > > > > 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the

...

> Do you use IDE drivers?

Yes.  The system uses IDE/PATA drivers (PIIX).

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

