Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYE2Osn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYE2Osn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYE2Osf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:48:35 -0400
Received: from vena.lwn.net ([206.168.112.25]:41348 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYE2Ose (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:48:34 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug #10708] V4L2-based build error 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sat, 24 May 2008 22:31:39 +0200."
             <TW_YzGo9TFP.A.rcE.9eIOIB@albercik> 
Date: Thu, 29 May 2008 08:48:34 -0600
Message-ID: <17813.1212072514@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki <rjw@sisk.pl> wrote:

> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10708
> Subject		: V4L2-based build error
> Submitter	: Jonathan Corbet <corbet@lwn.net>
> Date		: 2008-05-12 22:14 (13 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121063048408534&amp;w=4
> Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>

I just tried with 2.6.26-rc4 and was no longer able to reproduce the
problem; I think this one can be removed from the list.

jon
