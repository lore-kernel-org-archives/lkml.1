Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYERWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYERWRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYERWRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:17:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbYERWQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:16:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #10649] lxfb driver regression
Date: Mon, 19 May 2008 00:16:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Andres Salomon" <dilinger@queued.net>,
       "Jens Rottmann" <JRottmann@lippert-at.de>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.fn.4sBMIB@albercik> <20080518102041.54603340.akpm@linux-foundation.org>
In-Reply-To: <20080518102041.54603340.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805190016.57695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of May 2008, Andrew Morton wrote:
> On Sun, 18 May 2008 13:13:55 +0200 (CEST) "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10649
> > Subject		: lxfb driver regression
> > Submitter	: Andres Salomon <dilinger@queued.net>
> > Date		: 2008-05-07 21:08 (12 days old)
> > References	: http://lkml.org/lkml/2008/5/7/441
> > Handled-By	: Jens Rottmann <JRottmann@lippert-at.de>
> > Patch		: http://lkml.org/lkml/2008/5/8/207
> > 
> > 
> 
> This was addresed by the now-merged
> 
> commit 82f55af06af3d9c478292281ac37b48d2c43741e
> Author: Jens Rottmann <JRottmann@LiPPERT-AT.de>
> Date:   Wed May 14 16:05:32 2008 -0700
> 
>     fix "lxfb: extend PLL table to support dotclocks below 25 MHz"

Thanks, closed.
