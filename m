Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbYESPKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbYESPKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbYESPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:07:24 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:15537 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbYESPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:07:21 -0400
Date: Mon, 19 May 2008 08:07:14 -0700
From: Arthur Jones <ajones@riverbed.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [Bug #10718] [BUG] mm: bdi: export BDI attributes in sysfs
Message-ID: <20080519150714.GF23649@ajones-laptop.nbttech.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.t8G.wrBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7wuznNhcUqC.A.t8G.wrBMIB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it should still be listed...

Arthur

On Sun, May 18, 2008 at 04:13:56AM -0700, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10718
> Subject         : [BUG] mm: bdi: export BDI attributes in sysfs
> Submitter       : Arthur Jones <ajones@riverbed.com>
> Date            : 2008-05-14 14:40 (5 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121077684815315&amp;w=4
> Handled-By      : Miklos Szeredi <miklos@szeredi.hu>
>                   Linus Torvalds <torvalds@linux-foundation.org>
>                   Greg KH <greg@kroah.com>
> Patch           : http://marc.info/?l=linux-kernel&amp;m=121088552329700&amp;w=4
> 
> 
