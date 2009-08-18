Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZHRXtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZHRXtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZHRXtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:49:10 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57338 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZHRXtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:49:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19083.15853.600539.314231@pilspetsen.it.uu.se>
Date: Wed, 19 Aug 2009 01:49:01 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Andries Brouwer <aeb@cwi.nl>
Subject: Re: completely hide parts of the partition table from Windows?
In-Reply-To: <20090818233256.3e378f46@lxorguk.ukuu.org.uk>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
	<20090818233256.3e378f46@lxorguk.ukuu.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:
 > > Any recommendations? If no existing partition table format is suitable
 > > for my use case then I'm perfectly willing to invent a simple new format
 > > and add the corresponding parser to the kernel.
 > 
 > Or if its not the boot partition can you not just tell device mapper about
 > it and create a device mapper device of the offset ?

I have no experience with the device mapper, but I'll give it a
try and see how it works out. Thanks for the suggestion.
