Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYCNAUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYCNAUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYCNATw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:19:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:25005 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYCNATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k8XH4DzGY/8thEpmgyVjqVBcxz3X21uUpmfDyTdsW5LJWyKfkBV7mcvXTeUC6dN6pFx8FXQRzxTCmx4wJcPjNHeIcRbEX7PEnAGG6BrhheOkoK4N6X8FhB36K8iEPQOc2etm/PtPKq8HiKVoUsnLEwuvcJAp6SM5gg47uTLyOVg=
Message-ID: <9810cff90803131719p1c2c749eq7cdf9758840e9028@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:19:49 -0700
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>, mingo@elte.hu
Subject: Re: [PATCH RT 6/6] lockstat measurement extensions
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net, ak@suse.de,
       pavel@ucw.cz, acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <9810cff90803131718ge958e9fo9ae3f43b57f7654c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9810cff90803131703t3626d83fq727b04242f407c13@mail.gmail.com>
	 <9810cff90803131707v4fb3197fv396b8a5e8ae32b4d@mail.gmail.com>
	 <9810cff90803131709m3a5b1e5ep2bfe566b3c3bdb66@mail.gmail.com>
	 <9810cff90803131712l2777d1dex8c25f508369c48e7@mail.gmail.com>
	 <9810cff90803131715h1a93c9a1q86f480cf398d4dfb@mail.gmail.com>
	 <9810cff90803131718ge958e9fo9ae3f43b57f7654c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last one. Spin checking against the rtmutex->owner's run queue to
determine if an adaptive spin or not is useful.

bill
