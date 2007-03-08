Return-Path: <linux-kernel-owner+w=401wt.eu-S1030674AbXCHVpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030674AbXCHVpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030672AbXCHVpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:45:50 -0500
Received: from ns.suse.de ([195.135.220.2]:54629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030674AbXCHVps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:45:48 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: virtualization@lists.osdl.org
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Date: Thu, 8 Mar 2007 22:45:39 +0100
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <1173308717.24738.898.camel@localhost.localdomain> <20070308202350.GL10574@sequoia.sous-sol.org> <45F07334.7010207@goop.org>
In-Reply-To: <45F07334.7010207@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082245.39587.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Maybe hooking into genapic is the right way to mop up all the uses of
> send_IPI and its variants. 

It is.  More hooks in this are wouldn't be appreciated.

-Andi
