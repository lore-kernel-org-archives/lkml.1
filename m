Return-Path: <linux-kernel-owner+w=401wt.eu-S936354AbXGSPEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936354AbXGSPEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbXGSPET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:04:19 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:24489 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764700AbXGSPER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:04:17 -0400
In-Reply-To: <adalkdesyrs.fsf@cisco.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
To: Roland Dreier <rdreier@cisco.com>
Cc: OF-General <general@lists.openfabrics.org>,
       Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF00D945EC.C16B2992-ONC125731D.0052335C-C125731D.0052B490@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Thu, 19 Jul 2007 17:03:26 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 19/07/2007 17:03:50
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 17.07.2007 19:52:55:
> At a higher level, I'm left wondering why nobody talked about multiple
> EQs during the last months of the 2.6.22 process and now all of a
> sudden it becomes urgent in the last few days of the 2.6.23 merge
> window.  That's not really how I like to merge features....
OK, let keep multiple eqs for next release with a more stable
verbs def.
For the other patch to support MR with large pages we'll resend
it (without deps on multiple eqs patch) to you soon.
Regards
Nam

