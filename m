Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbXIZJI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbXIZJI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbXIZJID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:08:03 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:15624 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbXIZJH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:07:58 -0400
In-Reply-To: <200709251627.59040.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] PowerPC: Move of_device allocation into of_device.[ch]
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF0943F46C.2CC5F9D0-ONC1257362.0031D840-C1257362.003229B6@de.ibm.com>
Date: Wed, 26 Sep 2007 11:07:54 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 26/09/2007 11:07:55,
	Serialize complete at 26/09/2007 11:07:55
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote on 25.09.2007 16:27:57:

> The patch looks good to me, especially since you did exactly what I
> suggested ;-)

Yes, our discussions were very productive. Thanks and sorry I forgot to 
mention your input.
 
> Maybe the description should have another sentence in it about what
> the change is good for. You have that in the 0/5 mail, but that does
> not go into the changelog, so the information gets lost in the process.

Can do. New patch coming right up!

Joachim
