Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYB0Kzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYB0Kzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYB0Kzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:55:31 -0500
Received: from khc.piap.pl ([195.187.100.11]:42369 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYB0Kza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:55:30 -0500
To: Alan Cox <alan@redhat.com>
Cc: davids@webmaster.com, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
References: <MDEHLPKNGKAHNMBLJOLKKEONKKAC.davids@webmaster.com>
	<m3ir0bcnvo.fsf@maximus.localdomain>
	<20080227103120.GA1577@devserv.devel.redhat.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 27 Feb 2008 11:55:28 +0100
In-Reply-To: <20080227103120.GA1577@devserv.devel.redhat.com> (Alan Cox's message of "Wed\, 27 Feb 2008 05\:31\:20 -0500")
Message-ID: <m3mypmy8gv.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@redhat.com> writes:

>> D: top of the COPYING file explicity states binary modules are ok.
>
> Nope.

Right. Must have been somewhere else.
-- 
Krzysztof Halasa
