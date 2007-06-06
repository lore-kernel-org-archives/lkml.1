Return-Path: <linux-kernel-owner+w=401wt.eu-S936637AbXFFW4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936637AbXFFW4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965332AbXFFW4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:56:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13885 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533AbXFFW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:56:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=nmEhwdN0wv1L32+0fIBbY3F9YJHBgd6ANV9XPAa/bPMZVPgtss2FGK4nXIqiFWCKm
	8fL+8ysFzIP9AyuFf9M6w==
Date: Wed, 6 Jun 2007 15:53:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
In-Reply-To: <20070606222721.GB13713@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706061551210.23328@chino.kir.corp.google.com>
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com>
 <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com>
 <20070605211711.GD11693@frankl.hpl.hp.com>
 <alpine.DEB.0.99.0706051826330.23799@chino.kir.corp.google.com>
 <20070606222721.GB13713@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Stephane Eranian wrote:

> > Is this ia64 patch the one you mentioned that you did not post to LKML 
> > because it was too large in patch 0?  Is there any way you could break 
> > that patch up itself and post it for comments?
> > 
> Yes, this is the patch. It would be hard to break up in pieces.
> The reason it is big is because it has to remove the older IA-64-only
> implementation which was all in a single file whose size
> was bigger than 100kB. It is hard to break this, unless I explicitely
> remove the 'remove old file' diff from the patch.
> 

Could you provide it online somewhere so it can be downloaded, reviewed, 
and tested?
