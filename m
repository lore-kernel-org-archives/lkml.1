Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbYEKVUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbYEKVUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759512AbYEKVUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:20:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33251 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361AbYEKVUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:20:32 -0400
Message-ID: <4827631C.5030304@garzik.org>
Date: Sun, 11 May 2008 17:20:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Fisher <bug-track@fisher-privat.net>,
       Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [Bug #10619] [regression] ata2: device not ready (errno=-16),
 forcing hardreset
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.j0.yw1JIB@chimera>
In-Reply-To: <88YBFoyd1CN.A.j0.yw1JIB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10619
> Subject		: [regression] ata2: device not ready (errno=-16), forcing hardreset
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2008-05-08 06:49 (4 days old)


Fixed by 005b1f7495e812b99b73de5adbc73afd7a1cbcaf
