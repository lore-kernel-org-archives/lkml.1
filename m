Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbXFGHPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbXFGHPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXFGHP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:15:28 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:59065 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXFGHP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:15:27 -0400
Date: Thu, 7 Jun 2007 00:15:24 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
Message-ID: <20070607071524.GA14081@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com> <20070605211711.GD11693@frankl.hpl.hp.com> <alpine.DEB.0.99.0706051826330.23799@chino.kir.corp.google.com> <20070606222721.GB13713@frankl.hpl.hp.com> <alpine.DEB.0.99.0706061551210.23328@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706061551210.23328@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Wed, Jun 06, 2007 at 03:53:06PM -0700, David Rientjes wrote:
> On Wed, 6 Jun 2007, Stephane Eranian wrote:
> 
> > > Is this ia64 patch the one you mentioned that you did not post to LKML 
> > > because it was too large in patch 0?  Is there any way you could break 
> > > that patch up itself and post it for comments?
> > > 
> > Yes, this is the patch. It would be hard to break up in pieces.
> > The reason it is big is because it has to remove the older IA-64-only
> > implementation which was all in a single file whose size
> > was bigger than 100kB. It is hard to break this, unless I explicitely
> > remove the 'remove old file' diff from the patch.
> > 
> 
> Could you provide it online somewhere so it can be downloaded, reviewed, 
> and tested?

All the perfmon patches are available at:
	http://perfmon2.sf.net
-- 

-Stephane
