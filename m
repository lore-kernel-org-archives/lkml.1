Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZJ0IW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZJ0IW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbZJ0IWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:22:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZJ0IWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:22:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [Bug #14474] restorecond going crazy on 2.6.31.4 - inotify regression?
Date: Tue, 27 Oct 2009 09:24:40 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.H8F.Yef5KB@chimera> <51f3faa70910261648h242a9a2dp42cdf554a9eb1342@mail.gmail.com>
In-Reply-To: <51f3faa70910261648h242a9a2dp42cdf554a9eb1342@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910270924.41037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Robert Hancock wrote:
> On Mon, Oct 26, 2009 at 1:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14474
> > Subject         : restorecond going crazy on 2.6.31.4 - inotify regression?
> > Submitter       : Robert Hancock <hancockrwd@gmail.com>
> > Date            : 2009-10-16 0:03 (11 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125565159520489&w=4
> 
> This is definitely reproducible on 2.6.31.4 on CentOS 5.4, I'll likely
> try 2.6.31.5 shortly, but it doesn't seem like any of the 2.6.31.5
> patches touch inotify..

Thanks for the update.

Rafael
