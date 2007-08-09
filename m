Return-Path: <linux-kernel-owner+w=401wt.eu-S939551AbXHINN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939551AbXHINN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937323AbXHINNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:13:19 -0400
Received: from mx1.suse.de ([195.135.220.2]:53945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763610AbXHINNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:13:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] [0/12] x86 Late merge bug fixes for 2.6.23
Date: Thu, 9 Aug 2007 15:12:44 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070809241.425881000@suse.de> <20070809130630.GK3311@rhun.haifa.ibm.com>
In-Reply-To: <20070809130630.GK3311@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091512.44823.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 15:06:30 Muli Ben-Yehuda wrote:
> On Thu, Aug 09, 2007 at 02:41:27PM +0200, Andi Kleen wrote:
> > 
> > Various simple bug fixes, no new features. Please review.  I plan to
> > send them to Linus later.
> > 
> > I don't have anything else critical pending. If you believe a x86
> > patch is critical and really needs to make .23 please send email.
> 
> We also need this fix for the current sysdata regression:

I forgot to mention this -- plan to address the sysdata issues
was to ask Linus to revert the original patch. 

-Andi
