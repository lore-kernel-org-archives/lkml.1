Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYHYOEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYHYOEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYHYOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:04:25 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58639 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYHYOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:04:25 -0400
Date: Mon, 25 Aug 2008 17:03:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11356] Linux 2.6.27-rc3 - build failure: undefined
	reference to `.lockdep_count_forward_deps'
Message-ID: <20080825140343.GA4875@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.nrH.saGsIB@albercik> <200808240813.56525.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200808240813.56525.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 08:13:55AM +0200, Frans Pop wrote:
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

Sorry, I missed that Rafael had opened two bugs for two people reporting 
the same issue, and only closed the other one.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

