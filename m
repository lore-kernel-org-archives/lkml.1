Return-Path: <linux-kernel-owner+w=401wt.eu-S934820AbYAaRzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820AbYAaRzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765472AbYAaRzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:55:14 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56511 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYAaRzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:55:12 -0500
Date: Thu, 31 Jan 2008 19:55:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
Message-ID: <20080131175543.GH19700@cs181133002.pp.htv.fi>
References: <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist> <20080131074436.GA31966@uranus.ravnborg.org> <1201795051.3131.13.camel@localhost.localdomain> <20080131081120.27505dc0@laptopd505.fenrus.org> <20080131162141.GC19700@cs181133002.pp.htv.fi> <20080131090749.72781689@laptopd505.fenrus.org> <20080131171436.GG19700@cs181133002.pp.htv.fi> <20080131174526.GA2488@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131174526.GA2488@puku.stupidest.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 09:45:26AM -0800, Chris Wedgwood wrote:
> On Thu, Jan 31, 2008 at 07:14:36PM +0200, Adrian Bunk wrote:
> 
> > > cpuhotplug is required for suspend/resume.
> >
> > Not on UP computers.
> 
> those are less and less common now, most modern laptops are dual core

Who was talking about laptops?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

