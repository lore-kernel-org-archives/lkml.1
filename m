Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775Ab0AKWmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0AKWmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543Ab0AKWmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:42:09 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:62228 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0AKWmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=m5bzpJMtFHXBbVqUbMNbLxx1QpjG/tXVzn2kuMi0mFqoy2nti9XoV3r2YykfkdznvH
         xFgDJBAjS+2WnEiHQ7CTq7kKhmorKx6TBJviGq6mTdWnJYwchgQMsJkZVdPDs3t3/1fd
         j+NUwt6FHHS03bpBgQg2FARSvjr8sXeHwk878=
Date: Mon, 11 Jan 2010 23:41:59 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14948] EHCI resume sysfs duplicates
Message-ID: <20100111224159.GA9945@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
 <omZ8aBZReyD.A.1WH.ONlSLB@chimera>
 <20100111060541.GA19865@liondog.tnic>
 <201001112106.06787.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201001112106.06787.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 09:06:06PM +0100, Rafael J. Wysocki wrote:
> On Monday 11 January 2010, Borislav Petkov wrote:
> > On Sun, Jan 10, 2010 at 11:32:55PM +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14948
> > > Subject		: EHCI resume sysfs duplicates
> > > Submitter	: Borislav Petkov <petkovbb@googlemail.com>
> > > Date		: 2009-12-26 9:36 (16 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126182020615709&w=4
> > 
> > Preliminary and tested fix is at LKML-Reference: <20100105220829.GA31569@xanatos>
> 
> Sorry, I don't know how to resolve that.

Sorry about that. One way to resolve it would be:

http://marc.info/?i=<LKML-Reference>, i.e.

http://marc.info/?i=20100105220829.GA31569@xanatos

for example, which should get rewritten to

http://marc.info/?l=linux-usb&m=126272933202894

I'm sure there are other ways though.

-- 
Regards/Gruss,
    Boris.
