Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZGGUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZGGUfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbZGGUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:35:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737AbZGGUfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:35:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Date: Tue, 7 Jul 2009 22:35:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.xuF.70oUKB@chimera> <20090707162754.GA3304@localdomain.by>
In-Reply-To: <20090707162754.GA3304@localdomain.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072235.23610.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Sergey Senozhatsky wrote:
> On (07/07/09 02:00), Rafael J. Wysocki wrote:
> > 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13522
> > Subject		: BUG: scheduling while atomic
> > Submitter	: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> > Date		: 2009-06-12 19:29 (25 days old)
> > References	: http://lkml.org/lkml/2009/6/29/237
> > 
> 
> Hello Rafael,
> it should be listed.

Thanks for the update.

Best,
Rafael
