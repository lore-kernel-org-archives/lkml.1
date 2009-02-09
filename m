Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZBIEFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZBIEFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 23:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZBIEFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 23:05:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZBIEFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 23:05:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, ebiederm@xmission.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
In-Reply-To: Sukadev Bhattiprolu's message of  Saturday, 7 February 2009 13:20:22 -0800 <20090207212022.GA25353@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
	<20090207212022.GA25353@us.ibm.com>
X-Windows: form follows malfunction.
Message-Id: <20090209040453.9CBB0FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 20:04:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any comments on this patchset ? We are not sure about patch 7, but should
> I send the rest to Andrew ?

I think they are fine now if Oleg doesn't see any problems.  The /proc
change in patch 7 is a matter of taste and I just don't care either way.


Thanks,
Roland
