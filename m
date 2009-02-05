Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZBEPOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZBEPOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZBEPO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:14:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:58510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZBEPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:14:28 -0500
Date: Thu, 5 Feb 2009 07:14:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Nottingham <notting@redhat.com>
Cc: Harald Hoyer <harald@redhat.com>, linux-kernel@vger.kernel.org,
       power@bughost.org
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090205071444.390c19bc@infradead.org>
In-Reply-To: <20090205150705.GC6865@nostromo.devel.redhat.com>
References: <497F69A4.2070007@intel.com>
	<20090130202219.GA1253@ucw.cz>
	<20090203133251.GD29046@elte.hu>
	<gmeu0q$n13$1@ger.gmane.org>
	<20090205150705.GC6865@nostromo.devel.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 10:07:05 -0500
Bill Nottingham <notting@redhat.com> wrote:

> Harald Hoyer (harald@redhat.com) said: 
> > Can strace can be used on init?
> >
> > $ man strace
> > ...
> >        On Linux, exciting as it would be, tracing the init process
> > is forbidden. ...
> >
> > Any hope getting _any_ mechanism in the kernel??
> 
> The man page probably needs fixed - this works as of a few kernel
> releases ago.
> 

you can strace init but you can't strace X
(at least... last I tried it locked my box ;0)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
