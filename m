Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbXJOL0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbXJOL0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbXJOLZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:25:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61637 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764576AbXJOLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VUEJzUU54h0VemcFi/tnL3Y0CosI1mIK+AS+xgS+QPQkJ6rtXXDoSmcADP7wzYekXENwgW26V84SRUx7e3RiSm+L9h0ksY2ZW6kI+mGvNS43MD95Tmk7nnBYPICxIMh2Ic1eY1BCMgCr5Odup7VOhPqhGls+mm/rMGe5iTU77Bc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 15 Oct 2007 12:25:39 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com>
In-Reply-To: <47125633.3030404@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151225.39624.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 18:47, Gabriel C wrote:
> > Compile tested and applies cleanly to 2.6.23.
> > I don't have this hardware anymore and cannot run test these patches.
> 
> I can test these patches on an aic7892 controller later on today if you want.

I'd appreciate that.

Do you, by any chance, use aic94xx driver too (drivers/scsi/aic94xx/*)?
After i'm done with aic7xxx, I may attack this one.

> BTW while you seems to care about this driver could you have a look at :
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=3062 ?!?

I am a desktop Linux user, so far I don't use suspend at all. Sorry.
--
vda
