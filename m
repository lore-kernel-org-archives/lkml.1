Return-Path: <linux-kernel-owner+w=401wt.eu-S1762659AbYBZR1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762659AbYBZR1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYBZR1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:27:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbYBZR1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:27:43 -0500
Date: Tue, 26 Feb 2008 12:21:43 -0500
From: Alan Cox <alan@redhat.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: davids@webmaster.com, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080226172143.GA5445@devserv.devel.redhat.com>
References: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com> <m3d4qj90zm.fsf@maximus.localdomain> <m34pbv8x8s.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m34pbv8x8s.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 06:04:51PM +0100, Krzysztof Halasa wrote:
> Actually I think the _GPL exports are really harmful - somebody
> distributing a binary module may claim he/she doesn't violate the GPL
> because the module uses only non-GPL exports. OTOH GPL symbols give

They can claim that anyway. The can claim to be alien life forms too. Claim
is not the same as legal decision. From what I've seen its helped make binary
module abusers more cautious.

Alan

