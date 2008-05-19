Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbYESNoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbYESNoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbYESNnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:43:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59387 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbYESNnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:43:49 -0400
Date: Mon, 19 May 2008 15:44:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [Bug #10717] crossbuild fails in modpost
Message-ID: <20080519134427.GB20394@uranus.ravnborg.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.-CH.zrBMIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7wuznNhcUqC.A.-CH.zrBMIB@albercik>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 01:13:56PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10717
> Subject		: crossbuild fails in modpost
> Submitter	: Jiri Slaby <jirislaby@gmail.com>
> Date		: 2008-05-15 13:44 (4 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121085909512097&amp;w=4
> Handled-By	: Sam Ravnborg <sam@ravnborg.org>

This turns out to be a valid check which detected a bug.
So it is not a kbuild regression - and Jiri handles the issue from now on.
[He have just sent a patch: http://lkml.org/lkml/2008/5/19/203]

	Sam
