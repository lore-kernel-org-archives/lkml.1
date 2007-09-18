Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXIRUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXIRUlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXIRUll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:41:41 -0400
Received: from ns.suse.de ([195.135.220.2]:47194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbXIRUll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:41:41 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Charles N Wyble <charles@thewybles.com>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
Date: Tue, 18 Sep 2007 22:41:37 +0200
User-Agent: KMail/1.9.6
Cc: virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1189747054.7262.34.camel@localhost.localdomain> <200709182220.27311.ak@suse.de> <46F034A8.2070801@thewybles.com>
In-Reply-To: <46F034A8.2070801@thewybles.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182241.37771.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Actually if I understand the functionality of paravirt correctly that is
> not correct. I believe that will turn on the paravirt bits which allow
> it to run under things such as VMI or Xen.

You don't understand it correctly then.

-Andi
