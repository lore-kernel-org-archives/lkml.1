Return-Path: <linux-kernel-owner+w=401wt.eu-S1760397AbZDQVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397AbZDQVRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbZDQVRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:17:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42941 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbZDQVRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:17:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Bug #13106] 2.6.30-rc1: intel 3945 no wireless
Date: Fri, 17 Apr 2009 23:16:51 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <49E7D320.3080900@lwfinger.net> <49E7F5AF.8040702@gawab.com>
In-Reply-To: <49E7F5AF.8040702@gawab.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172316.51472.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Justin Madru wrote:
> Larry Finger wrote:
> > Rafael J. Wysocki wrote:
> >   
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.29.  Please verify if it still should be listed and let me know
> >> (either way).
> >>
> >>
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13106
> >> Subject		: 2.6.30-rc1: intel 3945 no wireless
> >> Submitter	: 2.6.30-rc1: intel 3945 no wireless
> >> Date		: 2009-04-08 5:36 (9 days old)
> >> References	: http://marc.info/?l=linux-kernel&m=123916905605534&w=4
> >>     
> >
> > That regression was fixed by Herbert Xu's commit 97c18e2c. It should no longer
> > be listed.
> >
> > Larry
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >   
> I'm the original submitter. I confirm that it's been fixed -- close bug.

Thanks for the confirmation, the bug has been closed already.

Rafael
