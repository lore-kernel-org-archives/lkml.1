Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbZBEBiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbZBEBiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758414AbZBEBiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:38:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762126AbZBEBiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:38:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
Date: Thu, 5 Feb 2009 02:37:38 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.zq.WwYiJB@chimera> <b6a2187b0902041115u130fcfe7ha1612e2e2fa1ec36@mail.gmail.com>
In-Reply-To: <b6a2187b0902041115u130fcfe7ha1612e2e2fa1ec36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050237.39394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Jeff Chua wrote:
> On Wed, Feb 4, 2009 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> > Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> > Date            : 2009-01-05 4:13 (31 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4
> 
> Latest linux git pull seems to behave slightly better. Restarting the
> interface a few times fixes the problem 70% of the time. The rest of
> the time, it can't associate with the AP.

Thanks for the update, there is a patch for you to test at
http://bugzilla.kernel.org/show_bug.cgi?id=12414#c3

Rafael
