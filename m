Return-Path: <linux-kernel-owner+w=401wt.eu-S936024AbYEURka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936024AbYEURka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbYEURkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:40:18 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:50752 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754713AbYEURkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:40:17 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Date: Wed, 21 May 2008 10:40:03 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080512205746.GB7401@us.ibm.com> <200805201316.33882.jbarnes@virtuousgeek.org> <20080521172956.GA8024@us.ibm.com>
In-Reply-To: <20080521172956.GA8024@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211040.03152.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2008 10:29 am Gary Hade wrote:
> > > > So assuming you're ok with your last patch, I'll stuff it into
> > > > linux-next.
> > >
> > > Works for me.  Thanks.
> >
> > Ok, just pushed the norom patch to linux-next.  I'll test it out, but it
> > would be good if you could try the tree out out on one of the problem
> > machines too.
>
> Jesse, I just tried 2.6.26-rc3-next-20080521 on one of
> those systems and the pci=norom option worked as expected.

Great, thanks.  I'll push it to Linus in the next merge window.

Jesse
