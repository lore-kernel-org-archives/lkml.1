Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYE2VTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYE2VTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbYE2VSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:18:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759939AbYE2VSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:18:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [Bug #10708] V4L2-based build error
Date: Thu, 29 May 2008 23:19:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
References: <17813.1212072514@vena.lwn.net>
In-Reply-To: <17813.1212072514@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292319.28384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 29 of May 2008, Jonathan Corbet wrote:
> Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10708
> > Subject		: V4L2-based build error
> > Submitter	: Jonathan Corbet <corbet@lwn.net>
> > Date		: 2008-05-12 22:14 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121063048408534&amp;w=4
> > Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> I just tried with 2.6.26-rc4 and was no longer able to reproduce the
> problem; I think this one can be removed from the list.

Thanks, closed.

Rafael
