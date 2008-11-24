Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYKXRu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYKXRu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKXRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:50:47 -0500
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:37372 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751029AbYKXRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:50:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=B+Rc3XoJZHn9N3Np6DquwiKPULA1jUblNeR4ZCN7aHml6jtQs7PWV6NfA1eRSI5Tucoojm3uJagtSPsMRqruQ6AOQKWt36+HuqpdBvJL85zqvcKN/kURnEGvkyRWIRnT;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12031] DRM enabled kernel hangs hard on resume on x60
Date: Mon, 24 Nov 2008 09:50:31 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.ATC.i7HKJB@chimera> <200811241436.21457.rjw@sisk.pl>
In-Reply-To: <200811241436.21457.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811240950.31829.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 24, 2008 5:36 am Rafael J. Wysocki wrote:
> On Saturday, 22 of November 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12031
> > Subject		: DRM enabled kernel hangs hard on resume on x60
> > Submitter	: Jens Axboe <jens.axboe@oracle.com>
> > Date		: 2008-11-12 18:42 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122651551216820&w=4
> > Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> I can reproduce this problem on Toshiba Portege R500, with the same
> symptoms (please see the bug entry for details).
>
> Well, we have at lease three DRM-related regressions in 2.6.28-rc and no
> visible reaction from the developers/maintainers of the code in question.
> :-(

Sorry, I've been away for awhile.  I'll dig through the latest info on these 
regressions today.

-- 
Jesse Barnes, Intel Open Source Technology Center

