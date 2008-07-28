Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYG1AsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYG1AsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYG1AsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:48:13 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:45933
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755932AbYG1AsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:48:12 -0400
Date: Sun, 27 Jul 2008 20:48:05 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: <benh@kernel.crashing.org>
Cc: "David Miller" <davem@davemloft.net>, <sfr@canb.auug.org.au>,
       <kkeil@suse.de>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>
Subject: Re: mISDN still breaking the allmodconfig build...
Message-ID: <20080727204805.59f55dda@lappy.seanm.ca>
In-Reply-To: <1217204022.11188.139.camel@pasglop>
References: <20080727.170235.97056809.davem@davemloft.net>
	<1217204022.11188.139.camel@pasglop>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 10:13:42 +1000
"Benjamin Herrenschmidt" <benh@kernel.crashing.org> wrote:

> On Sun, 2008-07-27 at 17:02 -0700, David Miller wrote:
> > More fallout from the premature mISDN driver merge:
> > 
> > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not
> > running on big endian machines now"
> 
> Lovely...

mISDN is notoriously bad on big endian machines. 

Cheers,
   Sean
