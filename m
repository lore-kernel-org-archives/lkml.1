Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYHTXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYHTXOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYHTXOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:14:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbYHTXOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:14:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
Date: Thu, 21 Aug 2008 01:17:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200808210045.42693.rjw@sisk.pl> <200808210058.06515.rjw@sisk.pl> <48ACA35C.7060907@zytor.com>
In-Reply-To: <48ACA35C.7060907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210117.41942.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> >>
> >> It starts working after a few minutes when the rsync has completed.
> > 
> > Well, it hasn't been working for a couple of hours now ...
> > 
> 
> My fault; I forgot to kick xinetd after updating the configuration file 
> for the git-daemon -> git daemon rename.

It works now, thanks for fixing.

Rafael
