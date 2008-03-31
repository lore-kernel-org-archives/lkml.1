Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYCaIPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYCaIPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYCaIPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:15:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:59577 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYCaIO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:14:59 -0400
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
In-Reply-To: <47F0491F.4050804@gmail.com>
References: <47F0491F.4050804@gmail.com>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 19:12:17 +1100
Message-Id: <1206951137.10388.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-31 at 10:14 +0800, Peter Teoh wrote:
> Interesting read:
> 
> http://research.sun.com/techrep/2006/smli_tr-2006-156.pdf
> 
> Personal comments:
> 
> Since KVM and Xen/OpenVZ etc other virtual machines are beginning to pop 
> up - I don't see why it inhibits (in spite of the many initial 
> difficulties as mentioned in the paper) the growth of using Java for 
> device drivers development.   Contrast it against udev - esp in terms of 
> usability/supportability/extensibility etc.   udev is a Linux thing, 
> whereas Java is at industry level.   If everyone write applications 
> device drivers using Java (minus the extreme hardware arch specific 
> stuff, but supports all the low level protocol specific stuff like 
> TCP/IP, NFS, USB etc) then I think it has potential to compete against C 
> lang - the monopolizer till today in the kernel world 
> (Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for 
> the Solaris in Linux, won't it be cool?

You're off by one day for an April fool...

Ben.


