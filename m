Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYKTLfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYKTLfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbYKTLdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:33:36 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:64462 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbYKTLdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pdsiuk8dInvCs7Y/kugqlrV87xmxhOlIuuSVWFSL7kV/f3ng5cKdFkoNgikWeSYELC
         BC2Ptck27Tjt+c/s2H1Ch3oESDG3RcxdtM0bnvpl3sMb0tQTZNvkcoVQ3kDar9WA5Pdf
         MYt16jrpLsThueH3Gm7/EhFUcXp8It+YWxdR8=
Date: Thu, 20 Nov 2008 05:33:29 -0600
From: Jay Cliburn <jcliburn@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: atl1-devel@lists.sourceforge.net, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [atl1-devel] atl2: don't mess up irq on suspend/resume
 (probably msi only)
Message-ID: <20081120053329.1722745f@osprey.hogchain.net>
In-Reply-To: <20081120.014420.256210031.davem@davemloft.net>
References: <4922FD09.2070007@tuffmail.co.uk>
	<49231CCB.8010900@tuffmail.co.uk>
	<20081119183443.7ca1cf23@osprey.hogchain.net>
	<20081120.014420.256210031.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 01:44:20 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Jay Cliburn <jcliburn@gmail.com>
> Date: Wed, 19 Nov 2008 18:34:43 -0600
> 
> > Can someone tell before I submit this patch if the description is
> > sane?
> > 
> > atl2: don't request irq on resume if netif running
> 
> It looks good, mind if I just apply this as-is?

Yes please.  Go right ahead.  Thanks.
