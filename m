Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656AbZH1Q23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbZH1Q23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZH1Q23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:28:29 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:53245 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZH1Q22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:28:28 -0400
X-IronPort-AV: E=Sophos;i="4.44,292,1249257600"; 
   d="scan'208";a="234521259"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       OF-EWG <ewg@lists.openfabrics.org>,
       OF-General <general@lists.openfabrics.org>,
       Hal Rosenstock <hnrose@comcast.net>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [ewg] [PATCH] IB/ehca: Construct MAD redirect replies from 	request MAD
References: <200908261337.56128.fenkes@de.ibm.com>
	<f0e08f230908260815g70de3002pfd0b34f1b17abd6@mail.gmail.com>
	<OFF2257478.FF0FEABE-ONC125761F.00344884-C125761F.00358310@de.ibm.com>
	<f0e08f230908270631j3e159f3fgb0034eb41acdac7b@mail.gmail.com>
	<OFA25F14CC.CE7042E9-ONC1257620.00453C46-C1257620.00474D70@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 28 Aug 2009 09:28:29 -0700
In-Reply-To: <OFA25F14CC.CE7042E9-ONC1257620.00453C46-C1257620.00474D70@de.ibm.com>
	(Joachim Fenkes's message of "Fri, 28 Aug 2009 14:58:49 +0200")
Message-ID: <adabplzsy1e.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Aug 2009 16:28:30.0167 (UTC) FILETIME=[93FEC670:01CA27FC]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Given that you seem to like the rest of the code and Jason hasn't spoken 
 > up yet, I think we can have Roland merge this patch. Roland, what do you 
 > think?

I don't see any problem with the idea and this does sound like a step
forward, so I am planning on merging this (pending review).
