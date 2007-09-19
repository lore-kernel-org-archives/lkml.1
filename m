Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbXISLL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbXISLL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXISLLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:11:50 -0400
Received: from khc.piap.pl ([195.187.100.11]:46354 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbXISLLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:11:49 -0400
To: Satyam Sharma <satyam@infradead.org>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>, Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iso9660 vs udf
References: <20070915214926.GA31416@mette>
	<20070918144734.GB13304@atrey.karlin.mff.cuni.cz>
	<alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in>
	<20070919004657.GB11444@mette>
	<alpine.LFD.0.999.0709190736140.28653@enigma.security.iitk.ac.in>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 19 Sep 2007 13:11:46 +0200
In-Reply-To: <alpine.LFD.0.999.0709190736140.28653@enigma.security.iitk.ac.in> (Satyam Sharma's message of "Wed, 19 Sep 2007 08:05:32 +0530 (IST)")
Message-ID: <m3ir66zz7x.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma <satyam@infradead.org> writes:

> What happened here is simply that in the absence of a "-t" option,
> mount(8) defaulted (probably due to incorrect heuristics?) to UDF for
> some reason, thereby obviously failing.

I think the CD contains both ISO-9660 and UDF filesystems, but the
latter is just faulty.

The disc would need to be analyzed.
-- 
Krzysztof Halasa
