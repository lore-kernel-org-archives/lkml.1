Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578AbZHAHC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbZHAHC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZHAHC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:02:26 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:62217 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbZHAHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:02:25 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Date: Sat, 1 Aug 2009 09:02:23 +0200
User-Agent: KMail/1.9.9
Cc: Dave Airlie <airlied@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907301341.01693.elendil@planet.nl> <7E82351C108FA840AB1866AC776AEC466D66A552@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC466D66A552@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908010902.25082.elendil@planet.nl>
X-OriginalArrivalTime: 01 Aug 2009 07:02:26.0250 (UTC) FILETIME=[06C512A0:01CA1276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 August 2009, Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: Frans Pop [mailto:elendil@planet.nl]
> >Sent: Thursday, July 30, 2009 4:41 AM
> >To: Dave Airlie
> >Cc: Rafael J. Wysocki; Linux Kernel Mailing List; Kernel
> >Testers List; Siddha, Suresh B; Pallipadi, Venkatesh
> >Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
> >
> Can you please check whether the patch here helps?
> http://bugzilla.kernel.org/show_bug.cgi?id=13884

Yes! That fixes it.

Thanks,
FJP
