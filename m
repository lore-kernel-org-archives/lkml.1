Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYH3VlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYH3VlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760298AbYH3Vf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:35:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760733AbYH3Vfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:35:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [Bug #11388] 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Date: Sat, 30 Aug 2008 23:39:57 +0200
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Joshua Hoblitt" <j_kernel@hoblitt.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.8uE.libuIB@albercik> <86802c440808301429u2a719571raf0d8001a89a1388@mail.gmail.com>
In-Reply-To: <86802c440808301429u2a719571raf0d8001a89a1388@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302339.58794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Yinghai Lu wrote:
> On Sat, Aug 30, 2008 at 12:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11388
> > Subject         : 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
> > Submitter       : Joshua Hoblitt <j_kernel@hoblitt.com>
> > Date            : 2008-08-20 17:38 (11 days old)
> >
> >
> >
> 
> this should be closed
> 
> commit	38cc1c3df77c1bb739a4766788eb9fa49f16ffdf
> x86: work around MTRR mask setting
> 
> fixed it.

Thanks, closed now.

Rafael
