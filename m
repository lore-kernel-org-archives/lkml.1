Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0BGNOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:14:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0BGNOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:14:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidjon@xenontk.org
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
Date: Sun, 7 Feb 2010 14:14:40 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       ykzhao <yakui.zhao@intel.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <201002022155.44016.rjw@sisk.pl> <4B6EB844.4090001@xenontk.org>
In-Reply-To: <4B6EB844.4090001@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002071414.40924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 February 2010, David John wrote:
> On 02/03/2010 02:25 AM, Rafael J. Wysocki wrote:
> > On Monday 01 February 2010, David John wrote:
> >> On 02/01/2010 06:13 AM, Rafael J. Wysocki wrote:
> >>> This message has been generated automatically as a part of a report
> >>> of regressions introduced between 2.6.31 and 2.6.32.
> >>>
> >>> The following bug entry is on the current list of known regressions
> >>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> >>> be listed and let me know (either way).
> >>>
> >>>
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
> >>> Subject		: i915: Commit 0e442c60 causes flickering
> >>> Submitter	: David John <davidjon@xenontk.org>
> >>> Date		: 2009-12-09 17:26 (54 days old)
> 
> Hi Rafael,
> 
> This regression entry can now be closed, it's fixed by the upstream
> commit 33c5fd12 (drm/i915: Disable SR when more than one pipe is enabled).

Thanks, closing.

Rafael
