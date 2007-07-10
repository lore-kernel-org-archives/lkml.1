Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbXGJNUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbXGJNUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbXGJNUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:20:13 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:8218 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXGJNUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:20:11 -0400
In-Reply-To: <adak5t9w7kx.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/13] IB/ehca: eHCA2 enablement & some fixes
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF1EC84A1D.3C3D1851-ONC1257314.003EEB89-C1257314.00495729@de.ibm.com>
Date: Tue, 10 Jul 2007 15:20:08 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 10/07/2007 15:20:09,
	Serialize complete at 10/07/2007 15:20:09
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 10.07.2007 00:11:42:

> thanks, I applied these for 2.6.23 and fixed a bunch of minor things
> that scripts/checkpatch.pl complained about (since I was in a mood to
> do mindless things).

Thanks! Both for the quick merge and for the fixes!

> In the future please run that yourself and clean
> up the obvious things.  I generally don't worry about the 80 column
> stuff, but it will catch most whitespace problems and tell you that
> foo(x,y) should be foo(x, y) etc.  So you don't have to completely
> silence the script but at least take a look at the output.

Didn't know about that script before, so thanks for the pointer!
I'll be sure to pass the next set of patches through it.

Joachim
