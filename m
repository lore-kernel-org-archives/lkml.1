Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZL2Wm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZL2Wm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZL2WmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:42:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZL2WmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:42:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vincent ETIENNE <ve@vetienne.net>
Subject: Re: [Bug #14906] boot problem bisected to commit 99935a7a59
Date: Tue, 29 Dec 2009 23:43:09 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.LvH.ZnhOLB@chimera> <200912292237.58999.ve@vetienne.net>
In-Reply-To: <200912292237.58999.ve@vetienne.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912292343.09795.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Vincent ETIENNE wrote:
> Le mardi 29 décembre 2009 16:09:58, Rafael J. Wysocki a écrit :
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14906
> > Subject		: boot problem bisected to commit 99935a7a59
> > Submitter	: Vincent ETIENNE <ve@vetienne.net>
> > Date		: 2009-12-19 16:07 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126123946509316&w=4
> > Handled-By	: Yinghai Lu <yinghai@kernel.org>
> > Patch		: http://patchwork.kernel.org/patch/68941/
> > 
> 
> The proposed patch works for me but the bug is still present in 2.6.33-rc2 
> (patch still aply cleanly in rc2 and continue to solve the problem). Have to 
> wait for rc3.

Thanks for the update.

Rafael
