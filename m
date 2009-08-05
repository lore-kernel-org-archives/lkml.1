Return-Path: <linux-kernel-owner+w=401wt.eu-S933521AbZHELgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbZHELgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933445AbZHELga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:36:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbZHELg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:36:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #13742] iwlagn (4965): regression when hardware rf switch is used
Date: Wed, 5 Aug 2009 13:36:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.i0D.fdgdKB@chimera> <200908051032.39357.elendil@planet.nl>
In-Reply-To: <200908051032.39357.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051336.36845.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Frans Pop wrote:
> On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me
> > know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13742
> > Subject	: iwlagn (4965): regression when hardware rf switch is used
> 
> Fix has just been included in mainline: 
> 2833b17062536e962b60795ad6378ef5c0b7be09

Thanks, closed.

Rafael
