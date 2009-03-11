Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZCKHwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZCKHwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZCKHvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 03:51:55 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:59516 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZCKHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:51:54 -0400
Message-ID: <49B76D91.1020807@free.fr>
Date: Wed, 11 Mar 2009 08:51:45 +0100
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Greg Kurz <gkurz@fr.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
References: <20090305163857.0C18F3FD@kernel> <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz> <20090305220044.GA2819@x200.localdomain> <1236352121.5732.80.camel@bahia> <20090306153549.GA898@us.ibm.com> <49B15F35.2010909@free.fr> <20090306183055.GA6729@us.ibm.com>
In-Reply-To: <20090306183055.GA6729@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> And if Ingo's requirement is fulfilled, would any C/R patchset be acceptable ?
> 
> Yup, no matter how hideous  :)  Ok not really.
> 
> But the point was that it wasn't Dave not understanding Alexey's
> suggestion, but Greg not understanding Ingo's.  If you think Ingo's
> goal isn't worthwhile or achievable, then argue that (as I am), don't
> keep elaborating on something we all agree will be needed (Alexey's
> suggestion or some other way of doing a true may-be-checkpointed test).

I rather spend my time on enabling things rather than forbid them. 

C.
