Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXECLTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXECLTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXECLTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:19:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:46373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXECLTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:19:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Bernhard Kaindl <bk@suse.de>
Subject: Re: [PATCH] [16/34] i386: fix mtrr sections
Date: Thu, 3 May 2007 13:19:34 +0200
User-Agent: KMail/1.9.6
Cc: randy.dunlap@oracle.com, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070430549.617098000@suse.de> <Pine.LNX.4.64.0705021559160.32650@jbgna.fhfr.qr> <Pine.LNX.4.64.0705031229300.27730@jbgna.fhfr.qr>
In-Reply-To: <Pine.LNX.4.64.0705031229300.27730@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031319.34353.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> As Andy already submitted it to Linus with http://lkml.org/lkml/2007/5/2/346
> we may have to create a patch which reverts this patch.

Ok thanks for the explanation. I will queue a revert patch
 
> I'm also planning to add some function headers to the MTRR functions
> and also fix the existing and upcoming function headers to be complant
> to kernel-doc.

Thanks

-Andi
