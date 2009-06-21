Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZFUNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZFUNu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZFUNuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:50:12 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44628 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZFUNuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:50:11 -0400
Message-ID: <4A3E3A8E.4030703@hp.com>
Date: Sun, 21 Jun 2009 09:50:06 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Martin Knoblauch <knobi@knobisoft.de>
CC: Matthew Wilcox <matthew@wil.cx>, Kay Sievers <kay.sievers@vrfy.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, mike.miller@hp.com, linux-pci@vger.kernel.org
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
References: <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com> <20090620165853.GL19977@parisc-linux.org> <ac3eb2510906201119r5c528a3s67cd04bdbfdd1d9c@mail.gmail.com> <20090620182617.GM19977@parisc-linux.org> <ac3eb2510906201136v4c6eac1bwffd2aed3e38c6ae1@mail.gmail.com> <20090620190630.GN19977@parisc-linux.org> <4A3D51D2.4080707@hp.com> <619506.56238.qm@web32605.mail.mud.yahoo.com>
In-Reply-To: <619506.56238.qm@web32605.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
> 
>  How do you get to see the debug-output from initrd? I never managed that.

I did all my boot testing from ILO with VSP for a serial console.

jim
