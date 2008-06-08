Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYFHQwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYFHQwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 12:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYFHQv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 12:51:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbYFHQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 12:51:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Bug #10816] vt/fbcon: fix background color on line feed
Date: Sun, 8 Jun 2008 18:52:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       thunder7 <thunder7@xs4all.nl>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.vND.B3vSIB@albercik> <alpine.LNX.1.10.0806080007040.20733@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0806080007040.20733@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081852.57541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 of June 2008, Jan Engelhardt wrote:
> 
> On Saturday 2008-06-07 22:42, Rafael J. Wysocki wrote:
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.25.  Please verify if it still should be listed.
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
> >Subject		: vt/fbcon: fix background color on line feed
> >Submitter	: thunder7 <thunder7@xs4all.nl>
> >Date		: 2008-05-27 19:33 (12 days old)
> >References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
> >Handled-By	: Jan Engelhardt <jengelh@medozas.de>
> >Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4
> >
> is upstream 774533b3e86fa52941c79aa80ab3f0cc511bba7f.

Thanks, closed.

Rafael
