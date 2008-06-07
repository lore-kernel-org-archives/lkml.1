Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbYFGP6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbYFGP6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbYFGP6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:58:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:59486 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682AbYFGP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dOUHN1mt8Wb2lNTIrog46B4AMZwqV3FGzwTDurcONG0ItSX6LVuGoIKb6gNe1LxTvV
         V8F5CfF+w0T62dEVAD+LQX5SUVtS4ayIjJWjBEu3vsJhO/M6Z8q8/Varb/IfF4Ifzmpk
         GzidGHW6e7f/kyLScA3P2JVDrkht8oXPblmmo=
Date: Sat, 7 Jun 2008 19:58:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] x86: io-apic cleanup
Message-ID: <20080607155808.GB7141@cvg>
References: <484aafbf.0407560a.301e.6a8c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484aafbf.0407560a.301e.6a8c@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Jun 07, 2008 at 07:53:55PM +0400]
| This series doesn't introduce any functional change but
| attempts to get rid of few hard-coded numbers in io-apic code.
| 
| Please review. Any comments are appreciated.
| 
| 		- Cyrill -
| -- 
| 

Btw, the series is made over tip/x86/apic

commit 2229ff84f01746d02fb6b79e156fb5cce48c908f
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jun 5 11:17:16 2008 +0200

    x86, io-apic: fix nmi_watchdog=1 bootup hang


		- Cyrill -
