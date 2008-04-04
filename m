Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYDDJpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYDDJpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYDDJoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:44:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYDDJox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:44:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: slub compile error
Date: Fri, 4 Apr 2008 11:45:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Toralf Foerster <toralf.foerster@gmx.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.kR.5DW9HB@albercik> <Pine.LNX.4.64.0804031836270.10635@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0804031836270.10635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041145.01486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 of April 2008, Christoph Lameter wrote:
> On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> 
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> 
> The bug was not in 2.6.24. It was introduced a couple of days 
> before 2.6.25-rc8 and the fix was the last commit added before rc8 was 
> released.

Bug closed.

Thanks,
Rafael
