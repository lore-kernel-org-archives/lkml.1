Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYDNBM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYDNBM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYDNBMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:12:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYDNBMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:12:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: [Bug #10344] [2.6.25-rc6] possible regression: X server dying
Date: Mon, 14 Apr 2008 03:13:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.Bu.C4lAIB@albercik> <4802AE84.4060400@imap.cc>
In-Reply-To: <4802AE84.4060400@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140313.24294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Tilman Schmidt wrote:
> Am 13.04.2008 20:56 schrieb Rafael J. Wysocki:
> > The following bug entry is on the current list of known regressions
> > from 2.6.24.  Please verify if it still should be listed.
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10344
> > Subject		: [2.6.25-rc6] possible regression: X server dying
> > Submitter	: Tilman Schmidt <tilman@imap.cc>
> > Date		: 2008-03-24 23:38 (21 days old)
> > References	: http://lkml.org/lkml/2008/3/24/260
> > Handled-By	: Dave Airlie <airlied@gmail.com>
> 
> I have reproduced the issue on kernel 2.6.22.17, so it looks like it's
> not a kernel regression, but an X server issue.

Thanks for the update.

I've dropped it from the list of recent regressions.

Thanks,
Rafael
