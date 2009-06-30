Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZF3WnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZF3WnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZF3WnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:43:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZF3WnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Fran=C3=A7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
Subject: Re: [Bug #13592] Root partition is not found
Date: Wed, 1 Jul 2009 00:43:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.TzD.RJASKB@chimera> <4A4A6AB0.4030206@tvcablenet.be>
In-Reply-To: <4A4A6AB0.4030206@tvcablenet.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907010043.22463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, François Valenduc wrote:
> Rafael J. Wysocki a écrit :
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13592
> > Subject		: Root partition is not found
> > Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
> > Date		: 2009-06-21 08:42 (8 days old)
> >
> >
> >
> >   
> In fact, this problem is already solved in 2.6.31-rc1.

Thanks, closed.

Best,
Rafael
