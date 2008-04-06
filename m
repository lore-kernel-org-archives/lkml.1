Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYDFUtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYDFUtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYDFUsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:48:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYDFUsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:48:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jasper Bryant-Greene <jasper@unix.geek.nz>
Subject: Re: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
Date: Sun, 6 Apr 2008 22:49:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <pdYe6zNQVl.A.XbB.vIW9HB@albercik> <1207512439.7405.1.camel@rhea.unix.geek.nz>
In-Reply-To: <1207512439.7405.1.camel@rhea.unix.geek.nz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062249.06273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of April 2008, Jasper Bryant-Greene wrote:
> No longer reproducible on 2.6.25-rc8.
> 
> Jasper
> 
> On Fri, 2008-04-04 at 01:05 +0200, Rafael J. Wysocki wrote:
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
> > Subject		: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
> > Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
> > Date		: 2008-02-13 12:25 (51 days old)
> > References	: http://lkml.org/lkml/2008/2/13/181

Thanks for the update, bug closed.

Rafael
