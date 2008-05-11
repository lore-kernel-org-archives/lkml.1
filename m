Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYEKVZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYEKVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYEKVZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:25:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34497 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbYEKVZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:25:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Bug #10619] [regression] ata2: device not ready (errno=-16), forcing hardreset
Date: Sun, 11 May 2008 23:25:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Fisher <bug-track@fisher-privat.net>,
       Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <htejun@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.j0.yw1JIB@chimera> <4827631C.5030304@garzik.org>
In-Reply-To: <4827631C.5030304@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805112325.39213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 of May 2008, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10619
> > Subject		: [regression] ata2: device not ready (errno=-16), forcing hardreset
> > Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> > Date		: 2008-05-08 06:49 (4 days old)
> 
> 
> Fixed by 005b1f7495e812b99b73de5adbc73afd7a1cbcaf

Thanks, closed.
