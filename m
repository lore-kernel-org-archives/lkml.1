Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZKYTLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZKYTLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbZKYTLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:11:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64544 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbZKYTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:11:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZzffWrvLjSV2pWvvqWiIlzfGgnHVmBclnOXlMtBMjLEOhq+hAu7zHWxy1N2qa55dpf
         PxCGlXVAyO9TSPVcC3tdLruH66soAUDiKPUYL1S69NrB9M87UhjFD74QtclLs/UobIMU
         9LBpwtwVQhrZOKfO4+Lf4qPH7izpr26kjhhWg=
Date: Wed, 25 Nov 2009 20:11:05 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091125191105.GA3167@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
 <20091124111946.GA7883@ff.dom.local>
 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 09:06:30AM -0500, Caleb Cushing wrote:
> > Anyway, since there are problems with
> > getting stats from the router we still can't compare them, or check
> > for the dropped stats. (Btw, could you check for /proc/net/softnet_stat
> > yet?)
> 
> router? good kernel? bad kernel?

router.

> 
> > So, it might be the kernel problem you reported, but there is not
> > enough data to prove it. Then my proposal is to try to repeat this
> > problem in more "testing friendly" conditions - preferably against
> > some other, more up-to-date linux box, if possible?
> 
> yeah 2.6.31.6 works on my laptop fine I'll just have to see about
> getting a direct connection to it. probably do that after I bring the
> other NIC back from home, on thanksgiving.

This other NIC is a really good idea, so let's wait and see.

Happy Thanksgiving!
Jarek P.
