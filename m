Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZIPFqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZIPFqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZIPFqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:46:49 -0400
Received: from complete.lackof.org ([198.49.126.79]:33576 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZIPFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:46:49 -0400
Date: Tue, 15 Sep 2009 23:46:52 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: "Kay, Allen M" <allen.m.kay@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding
Message-ID: <20090916054652.GB17670@lackof.org>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com> <1253059937.11643.527.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253059937.11643.527.camel@desktop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 05:12:17PM -0700, Daniel Walker wrote:
...
> Both times that you've submitted this the patch has been corrupt.. Your
> mailer, or something is adding little "=20" or "=3D" all over. For
> instance,
> 
> "Signed-off-by: Allen Kay allen.m.kay@intel.com
> 
> ---
> 
>  drivers/pci/pci.c        |   37 +++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h        |    1 +
>  drivers/pci/probe.c      |    3 +++
>  include/linux/pci_regs.h |   14 ++++++++++++++
>  4 files changed, 55 insertions(+)
> 
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I did not see any "=3D" in the posting - using "mutt" to read the email.

And AFAIK, many maintainers will accept attachments if that's what works.
Sure, it's not preferred, but pragmatic folks manage to get over that.

hth
grant
