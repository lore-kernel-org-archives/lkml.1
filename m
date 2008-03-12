Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYCLW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYCLW3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYCLW3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:29:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbYCLW3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:29:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Date: Wed, 12 Mar 2008 23:28:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Lennert Buytenhek <buytenh@wantstofly.org>,
       Linas =?utf-8?q?=C5=BDvirblis?= <0x0007@gmail.com>
References: <200803120141.51844.rjw@sisk.pl> <20080312194035.GA23482@dose.home.local>
In-Reply-To: <20080312194035.GA23482@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803122328.19285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Tino Keitel wrote:
> On Wed, Mar 12, 2008 at 01:41:51 +0100, Rafael J. Wysocki wrote:
> 
> Hi,
> 
> [...]
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
> > Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> > Submitter	: Linas Žvirblis <0x0007@gmail.com>
> > Date		: 2008-02-13 22:38 (29 days old)
> > References	: http://lkml.org/lkml/2008/2/13/566
> 
> could this be connected to http://lkml.org/lkml/2008/3/12/77?

Yes, it could.

We've asked Linas already to test the current mainline.

Thanks,
Rafael
