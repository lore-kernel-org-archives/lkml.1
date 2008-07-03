Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYGCTht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYGCTht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYGCThl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:37:41 -0400
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:50703 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405AbYGCThk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:37:40 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] PCI: make pci_name use dev_name
Date: Thu, 3 Jul 2008 12:37:30 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, davem@davemloft.net
References: <20080702153524.GA30318@kroah.com> <20080702160422.GA2655@suse.de> <20080702202200.GA14021@kroah.com>
In-Reply-To: <20080702202200.GA14021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031237.31063.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 02, 2008 1:22 pm Greg KH wrote:
> On Wed, Jul 02, 2008 at 09:04:22AM -0700, Greg KH wrote:
> > Well, it's only used in 837 different places, so it might take me a few
> > hours to ensure I catch all the usages :(
>
> Ok, here are 4 patches that fix the few places that this pci change
> caused problems.
>
> Jesse, do you want to add these to your tree?  I can take the single USB
> one if you want, or you can take all 4, it's fine with me.

I'd rather just take the PCI patch (which I'm doing now).  The other stuff can 
come in through the appropriate tree.

Thanks,
Jesse
