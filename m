Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756092AbYKKJEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYKKJEw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 11 Nov 2008 04:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYKKJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:04:09 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:54201 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbYKKJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:04:07 -0500
In-Reply-To: <adaod0nqpx4.fsf@cisco.com>
References: <200806061835.43802.fenkes@de.ibm.com>	<48499C11.7030504@gmail.com> <200811071742.51867.fenkes@de.ibm.com> <adaod0nqpx4.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Alexander Schmidt1 <ALEXSCHM@de.ibm.com>,
        Christoph Raisch <RAISCH@de.ibm.com>,
        OF-EWG <ewg@lists.openfabrics.org>,
        OF-General <general@lists.openfabrics.org>,
        Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
        Roland Dreier <rolandd@cisco.com>,
        Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Fix suppression of port activation events
X-KeepSent: A167ACE2:B60DCF5C-C12574FE:00319074;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 HF105 April 10, 2008
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFA167ACE2.B60DCF5C-ONC12574FE.00319074-C12574FE.0031CE5F@de.ibm.com>
Date: Tue, 11 Nov 2008 10:04:04 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.1|February 07, 2008) at
 11/11/2008 10:04:04,
	Serialize complete at 11/11/2008 10:04:04
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 10.11.2008 21:36:23:

>  > A previous fix introduced a regression where port activation events 
were
>  > dropped unconditionally if port autodetection was not enabled. Fixed.
> 
> Is this a fix to "IB/ehca: Remove reference to special QP in case of
> port activation failure"?  Because if so I can roll it into that patch,
> since Linus hasn't pulled it yet.

Yes, that would be splendid, thank you!

Cheers,
  Joachim
