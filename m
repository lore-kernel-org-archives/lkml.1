Return-Path: <linux-kernel-owner+w=401wt.eu-S933378AbZGPVON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbZGPVON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 17:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbZGPVOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 17:14:12 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46445 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbZGPVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 17:14:12 -0400
From: Christian =?iso-8859-1?q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Organization: IBM
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: regression post 2.6.30: device mapper fails on some logical volumes
Date: Thu, 16 Jul 2009 23:14:03 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-release; KDE/4.2.4; i686; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200907151852.15121.borntraeger@de.ibm.com> <200907161746.06935.borntraeger@de.ibm.com> <20090716202028.GA9005@redhat.com>
In-Reply-To: <20090716202028.GA9005@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907162314.10118.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 16 Juli 2009 22:20:29 schrieb Mike Snitzer:
> > The logical volumes space-test and space-home still dont appear.
>
> I'm fairly certain that this pending fix will resolve your issues:
> http://patchwork.kernel.org/patch/33534/
>
> I'm not sure when Alasdair intends to push it to Linus but it should be
> soon.

Yes, it does. Thank you for your help.

> http://patchwork.kernel.org/patch/33534/
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>


