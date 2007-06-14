Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbXFNIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbXFNIrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXFNIrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:47:05 -0400
Received: from khc.piap.pl ([195.187.100.11]:39308 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXFNIrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:47:05 -0400
To: holzheu@linux.vnet.ibm.com
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
References: <1181747217.29512.9.camel@localhost.localdomain>
	<17542.1181753455@turing-police.cc.vt.edu>
	<1181758277.26375.17.camel@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 14 Jun 2007 10:47:00 +0200
In-Reply-To: <1181758277.26375.17.camel@localhost.localdomain> (holzheu@linux.vnet.ibm.com's message of "Wed, 13 Jun 2007 20:11:17 +0200")
Message-ID: <m3ir9q6hyz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

holzheu <holzheu@linux.vnet.ibm.com> writes:

> If the information is to big for the printk itself, because you would
> need 10 lines to explain what happened, wouldn't it be good to have a
> place where to put that information?

I think if a message really has to be 10 lines long to be clear then
it should just be 10 lines long. The keyword is "really".

Example: oops.
-- 
Krzysztof Halasa
