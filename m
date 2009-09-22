Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZIVTsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZIVTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZIVTst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:48:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZIVTss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:48:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] PCI PM: Read device power state from register after updating it (rev. 2)
Date: Tue, 22 Sep 2009 21:50:01 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-pci@vger.kernel.org, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090922080747.GA20853@rhlx01.hs-esslingen.de>
In-Reply-To: <20090922080747.GA20853@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909222150.01185.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Andreas Mohr wrote:
> Hi Rafael,

Hi,

> first you say "returning an error code in such cases would..."
> and then the patch content has...?

I don't quite understand your comment, care to elaborate?

Rafael
