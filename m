Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbXE2Mop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbXE2Mop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764797AbXE2Moh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:44:37 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35188 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764718AbXE2Mog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:44:36 -0400
In-Reply-To: <adalkfe6rxk.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Refactor "maybe missed event" code
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFA7B951E3.8AFF22C4-ONC12572EA.0045F4E8-C12572EA.00461997@de.ibm.com>
Date: Tue, 29 May 2007 14:44:32 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 29/05/2007 14:44:34,
	Serialize complete at 29/05/2007 14:44:34
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 24.05.2007 19:40:39:

> This isn't fixing anything is it?  I think it's 2.6.23 material;
> correct me if I'm wrong.

Right, it doesn't fix things, just coalesces some code.

Joachim
