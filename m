Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZIPJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZIPJEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbZIPJEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:04:16 -0400
Received: from fifo99.com ([67.223.236.141]:42116 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZIPJEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:04:15 -0400
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding
From: Daniel Walker <dwalker@fifo99.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: "Kay, Allen M" <allen.m.kay@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
In-Reply-To: <20090916054652.GB17670@lackof.org>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
	 <1253059937.11643.527.camel@desktop>  <20090916054652.GB17670@lackof.org>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 02:05:10 -0700
Message-Id: <1253091910.11643.567.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 23:46 -0600, Grant Grundler wrote:
> On Tue, Sep 15, 2009 at 05:12:17PM -0700, Daniel Walker wrote:
> ...
> > Both times that you've submitted this the patch has been corrupt.. Your
> > mailer, or something is adding little "=20" or "=3D" all over. For
> > instance,
> > 
> > "Signed-off-by: Allen Kay allen.m.kay@intel.com
> > 
> > ---
> > 
> >  drivers/pci/pci.c        |   37 +++++++++++++++++++++++++++++++++++++
> >  drivers/pci/pci.h        |    1 +
> >  drivers/pci/probe.c      |    3 +++
> >  include/linux/pci_regs.h |   14 ++++++++++++++
> >  4 files changed, 55 insertions(+)
> > 
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 
> I did not see any "=3D" in the posting - using "mutt" to read the email.

I've seen them in two different mailing systems, so I'm pretty sure they
are there.

> And AFAIK, many maintainers will accept attachments if that's what works.
> Sure, it's not preferred, but pragmatic folks manage to get over that.

Sure in a pinch, but learning how to do it a better way is good too.

Daniel

