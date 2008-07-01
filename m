Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbYGAUtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbYGAUtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYGAUsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:48:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYGAUsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:48:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Date: Tue, 1 Jul 2008 22:50:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <200807012239.44105.rjw@sisk.pl> <486A96C1.2020106@firstfloor.org>
In-Reply-To: <486A96C1.2020106@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012250.39930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Andi Kleen wrote:
> 
> > I have tested it on the nx6325 (64-bit) on top of the today's linux-next.  It
> > works fine for me.
> 
> Could a few more people with different laptops please test too?

Well, I think we can put it into the 2.6.27 queue in the hope it gets more
testing in linux-next over time.

Thanks,
Rafael
