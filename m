Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbYJTXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbYJTXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYJTXZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:25:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:46661 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYJTXZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:25:17 -0400
Subject: Re: [RFC PATCH 0/5] patches for a network-based hvc backend (s390)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20081014091247.433079967@linux.vnet.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 10:23:37 +1100
Message-Id: <1224545017.7654.188.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 11:12 +0200, Hendrik Brueckner wrote:
> Hello,
> 
> I work on a network-based hvc console backend for s390 that allows
> to get "full-screen" terminal access to z/VM guest machines.
> The solution consists of a HVC backend that provides the terminal interface;
> and a tool to connect to the terminal via a z/VM specific communication
> protocol.

 .../...

Hi !

What's the status with that patch serie ? Is this 2.6.28 material ?
Alan, are you ok with those ? Hendrik, have there been any respin other
than v2 of patch 4/5 ?

I can merge it via powerpc but it's getting late in the merge window...

Cheers,
Ben.


