Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZE2JaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZE2JaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZE2J36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:29:58 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:47785 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbZE2J35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:29:57 -0400
From: Christian =?utf-8?q?Borntr=C3=A4ger?= <borntraeger@de.ibm.com>
Organization: IBM
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] KVM: add localversion to avoid confusion and conflicts
Date: Fri, 29 May 2009 11:29:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-self-00072-g279e677-dirty; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
References: <1243581494.3212.1.camel@localhost.localdomain> <200905290948.34482.borntraeger@de.ibm.com> <1243586626.4379.15.camel@localhost.localdomain>
In-Reply-To: <1243586626.4379.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905291129.30296.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 Mai 2009 10:43:46 schrieb Jaswinder Singh Rajput:
> > > Adding localversion avoids confusion in kernel images :
> > NAK from my side. If you need a distinction, there is always
> Here is NAK for your NAK from my side.
> This patch is only for KVM tree and not for linus tree.

I know that this is for the kvm tree.
I personally dont like to have a forced localversion in my kernel trees - it 
might break my tooling. 
Anyway, If it really makes your life better I can live with these localversion 
files and adopt my tooling.


