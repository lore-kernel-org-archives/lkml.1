Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbYBKSEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbYBKSEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYBKSEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:04:46 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:37928 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYBKSEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:04:45 -0500
Date: Mon, 11 Feb 2008 20:04:41 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Roskin <proski@gnu.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jan Beulich <jbeulich@novell.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH v2] x86: explicit call to mmiotrace in
 do_page_fault()
Message-ID: <20080211200441.04816f8c@daedalus.pq.iki.fi>
In-Reply-To: <1202695958.24474.22.camel@dv>
References: <1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	<20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	<20080207125327.GB27234@elte.hu>
	<20080207125622.GA7111@infradead.org>
	<20080209195255.584d4157@daedalus.pq.iki.fi>
	<1202582370.16505.6.camel@lappy>
	<20080210200521.6278d39f@daedalus.pq.iki.fi>
	<1202695958.24474.22.camel@dv>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it seems 2.6.25-rc1 is out and mmiotrace did not make it. Thank you all
for your feedback.

Ingo, you can throw away all my patches. I will start from scratch and
come back when I have made mmiotrace built-in-able and got rid of the
page fault hook. It should make a nicer patch set as a whole.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
