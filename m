Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZG2TIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZG2TIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZG2TIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:08:18 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:51081 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbZG2TIQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:08:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 21:08:12 +0200
User-Agent: KMail/1.9.9
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       hirofumi@mail.parknet.co.jp, aneesh.kumar@linux.vnet.ibm.com,
       rjw@sisk.pl, ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <200907292028.32320.elendil@planet.nl> <200907291443.13983.gene.heskett@verizon.net>
In-Reply-To: <200907291443.13983.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907292108.15839.elendil@planet.nl>
X-OriginalArrivalTime: 29 Jul 2009 19:08:16.0189 (UTC) FILETIME=[ED5126D0:01CA107F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Gene Heskett wrote:
> Yes, some of it will.  But thanks to fedora's broken disk partitioner,
> something I've been screaming about for a damned decade, my /boot
> partition isn't big enough to absorb a whole chain of those, hence the
> fixed version request.

My /boot isn't big enough for a full series either, but my $HOME is :-)

The fact that the packages I create all have the same package name and 
only the package version differs, means that I do get the complete series 
but only have one version installed in /boot at any time (as installing a 
new version overwrites the version from the previous bisect iteration). 

No idea if you can do the same on an RPM-based system easily.
