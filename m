Return-Path: <linux-kernel-owner+w=401wt.eu-S936165AbXJSSuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936165AbXJSSuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764934AbXJSSty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:49:54 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:40776 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328AbXJSStw (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:49:52 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
Date: Fri, 19 Oct 2007 20:49:47 +0200
User-Agent: KMail/1.9.7
Cc: "Laurent Vivier" <Laurent.Vivier@bull.net>, carsteno@de.ibm.com,
       "Mike Lampard" <mike@secnet.net.au>, Linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Aurelien Jarno" <aurelien@aurel32.net>
References: <47189371.7080104@de.ibm.com> <200710191723.48104.borntraeger@de.ibm.com> <68676e00710190843l740698ffv478375665773263@mail.gmail.com>
In-Reply-To: <68676e00710190843l740698ffv478375665773263@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192049.48008.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 19. Oktober 2007 schrieb Luca Tettamanti:
> linus-git has at least one bug with SG chaining, but usually it just
> hangs the machine. Patch is here:
> 
> http://lkml.org/lkml/2007/10/17/269

Looks promising.
I pulled this fix by pulling the latest Linus-git into the kvm.git. I also 
enabled some debug options in the kernel hacking section. This resulting 
kernel seems to be stable so far. We will see in the next days if the problem
is really gone.

Thanks to all for your ideas. 

Christian
