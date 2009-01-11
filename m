Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZAKSw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZAKSw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZAKSwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:52:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZAKSwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:52:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland (=?utf-8?b?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
Subject: Re: [Bug #12413] iwl3945 - Error for wireless request "Set Encode" (8B2A)
Date: Sun, 11 Jan 2009 19:51:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.Gn.LafaJB@chimera> <20090111190455.21b2f7f2@tux.DEF.witbe.net>
In-Reply-To: <20090111190455.21b2f7f2@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111951.32544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Paul Rolland wrote:
> Hello,
> 
> On Sun, 11 Jan 2009 12:41:09 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12413
> > Subject		: iwl3945 - Error for wireless request "Set
> > Encode" (8B2A) Submitter	: Paul Rolland <rol@witbe.net>
> > Date		: 2009-01-02 18:32 (10 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123092155803366&w=4
> > 
> 
> This is fixed. Please consider it as a user-bug if you want. 
> Anyway, the fix was to enable :
>  
> "Intel Wireless WiFi Next Gen AGN"
> 
> in addition to the already enabled support for the iwl3945. 
> Not sure why we now need to enable both, but this solved the problem
> for me.
> Wifi is now fully functional.

Thanks for the update, the bug has been closed.

Rafael
