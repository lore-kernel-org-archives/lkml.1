Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570Ab0ABNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0ABNla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344Ab0ABNl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:41:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0ABNl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:41:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [Bug #14935] hd-audio0 eats 25% CPU (according to top)
Date: Sat, 2 Jan 2010 14:41:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Takashi Iwai" <tiwai@suse.de>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.wuG.KnhOLB@chimera> <20100102013323.3651b95a@mosly>
In-Reply-To: <20100102013323.3651b95a@mosly>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001021441.37518.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 January 2010, Sergei Trofimovich wrote:
> On Tue, 29 Dec 2009 16:10:01 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14935
> > Subject		: hd-audio0 eats 25% CPU (according to top)
> > Submitter	: Sergei Trofimovich <slyich@gmail.com>
> > Date		: 2009-12-25 10:21 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126173644210280&w=4
> > Handled-By	: Takashi Iwai <tiwai@suse.de>
> > Patch		: http://patchwork.kernel.org/patch/69747/
> 
> Merged upstream as: 729d55ba972348234759f8e40abf8de020f0d505 (aka v2.6.33-rc2-2-g729d55b)
> I've tested v2.6.33-rc2-249-gcd6e125 and it fixes problem.

Thanks, closed.

Rafael
