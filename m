Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZGULHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZGULHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZGULHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:07:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZGULHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:07:07 -0400
Date: Tue, 21 Jul 2009 13:07:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, aris@redhat.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding II
Message-ID: <20090721110705.GC29028@basil.fritz.box>
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com> <20090720194419.GD16072@basil.fritz.box> <20090721105105.GE32338@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721105105.GE32338@aftab>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:51:05PM +0200, Borislav Petkov wrote:
> On Mon, Jul 20, 2009 at 09:44:19PM +0200, Andi Kleen wrote:
> 
> > As far as I can see this whole thing barely works even on AMD
> > due to the other problems.
> 
> Care to let us in on those so that we get a chance to fix them?

Like I described in my earlier emails. You don't even catch CE errors
which are the 90%+ case.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
