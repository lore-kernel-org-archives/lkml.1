Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYHXVHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYHXVHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYHXVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:06:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53993 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYHXVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:06:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #11356] Linux 2.6.27-rc3 - build failure: undefined reference to `.lockdep_count_forward_deps'
Date: Sun, 24 Aug 2008 23:10:48 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.nrH.saGsIB@albercik> <200808240813.56525.elendil@planet.nl>
In-Reply-To: <200808240813.56525.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808242310.48795.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of August 2008, Frans Pop wrote:
> On Saturday 23 August 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11356
> > Subject	: Linux 2.6.27-rc3 - build failure: undefined reference to
> > 		  `.lockdep_count_forward_deps'
> > Submitter	: Frans Pop <elendil@planet.nl> 
> > Date		: 2008-08-16 19:11 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121891396320127&w=4
> 
> Fixed as per: http://marc.info/?l=linux-kernel&m=121898767530602&w=4
> Adrian mentioned that he'd closed the bug, but apparently not.

The bug is closed now.

Thanks,
Rafael



