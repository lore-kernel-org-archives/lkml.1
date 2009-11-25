Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZKYHMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZKYHMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZKYHML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:12:11 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41731 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZKYHML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:12:11 -0500
Message-ID: <4B0CD8D0.20600@cs.helsinki.fi>
Date: Wed, 25 Nov 2009 09:12:16 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: David Rientjes <rientjes@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
References: <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx> <1259095580.4531.1788.camel@laptop> <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop> <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com> <1259097150.4531.1822.camel@laptop> <alpine.DEB.2.00.0911241313220.12339@chino.kir.corp.google.com> <1259098552.4531.1857.camel@laptop> <alpine.DEB.2.00.0911241336550.12339@chino.kir.corp.google.com> <20091124222351.GL6831@linux.vnet.ibm.com>
In-Reply-To: <20091124222351.GL6831@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney kirjoitti:
> As for me, as long as SLAB is in the kernel and is default for some
> of the machines I use for testing, I will continue reporting any bugs
> I find in it.  ;-)

Yes, thanks for doing that. As long as SLAB is in the tree, I'll do my 
best to get them fixed.

			Pekka
