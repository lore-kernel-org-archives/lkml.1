Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbYECIje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbYECIje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 04:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbYECIjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 04:39:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35971 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbYECIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 04:39:22 -0400
Date: Sat, 3 May 2008 10:45:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: Markus Metzger <markus.t.metzger@intel.com>, andi-suse@firstfloor.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
Message-ID: <20080503084556.GA25419@one.firstfloor.org>
References: <20080430135440.A359@sedona.ch.intel.com> <20080503014342.3882226FA07@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503014342.3882226FA07@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, on more substantive concerns.  This is heading in the right general
> direction, to having a well-specified internal interface to build from.

That's actually an unusual requirement for Linux, a Roland Special. Normally 
we don't do complicated internal interfaces that are not used by anything yet.

-Andi
