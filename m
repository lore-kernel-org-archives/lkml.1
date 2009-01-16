Return-Path: <linux-kernel-owner+w=401wt.eu-S937559AbZAPVQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937559AbZAPVQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764371AbZAPVQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:16:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51066 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZAPVQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:16:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 7/7] PCI PCIe portdrv: Implement pm object
Date: Fri, 16 Jan 2009 22:15:46 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl> <200901131448.41843.rjw@sisk.pl> <200901161020.01955.jbarnes@virtuousgeek.org>
In-Reply-To: <200901161020.01955.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901162215.46845.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Jesse Barnes wrote:
> On Tuesday, January 13, 2009 5:48 am Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Implement pm object for the PCI Express port driver in order to use
> > the new power management framework and reduce the code size.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I applied this series.

Thanks!

> Hopefully you can Kenji-san can get on the same page 
> wrt MSI vector handling so we can apply the last one from one of you. :)

We will. :-)

Best,
Rafael
