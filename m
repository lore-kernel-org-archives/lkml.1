Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXJSOTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXJSOTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXJSOS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:18:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36563 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253AbXJSOS6 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:18:58 -0400
Date: Fri, 19 Oct 2007 16:18:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: carsteno@de.ibm.com
cc: Mike Lampard <mike@secnet.net.au>, kvm-devel@lists.sourceforge.net,
       Aurelien Jarno <aurelien@aurel32.net>, Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
In-Reply-To: <4718B4DB.1000202@de.ibm.com>
Message-ID: <Pine.LNX.4.64.0710191618450.1997@fbirervta.pbzchgretzou.qr>
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net>
 <47189706.1040809@de.ibm.com> <200710192127.17584.mike@secnet.net.au>
 <4718A14B.4060008@de.ibm.com> <4718B4DB.1000202@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 19 2007 15:44, Carsten Otte wrote:
> Carsten Otte wrote:
>> First thing we do, is figure whether or not 2.6.23.1 as released breaks our
>> system too. This way, we can either focus on differences between Linus and
>> Avi, or turn on the big red warning sign saying "regression".
>
> Looks like 2.6.23.1 works fine on that box. We'll leave it running over
> the weekend with "while true; do make; make clean; done".

Well, do you happen to use sata_mv?
