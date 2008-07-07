Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYGGXD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYGGXD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYGGXDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:03:19 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:45784 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754067AbYGGXDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:03:18 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] sparc64: fix up bus_id changes in sparc core code
Date: Mon, 7 Jul 2008 16:03:11 -0700
User-Agent: KMail/1.9.9
Cc: gregkh@suse.de, kay.sievers@vrfy.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080702153651.GB30318@kroah.com> <20080703164939.GA13326@suse.de> <20080703.134416.115438394.davem@davemloft.net>
In-Reply-To: <20080703.134416.115438394.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071603.11503.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 03, 2008 1:44 pm David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Thu, 3 Jul 2008 09:49:39 -0700
>
> > Argh, I'm patching against a previous patch that was only sent to Jesse
> > for the PCI core, sorry for the confusion.
> >
> > The patch for that is below.  It's probably easier for Jesse to take
> > both of these in his tree if you like, or I can send you just the Sparc
> > one, based on HEAD right now, and then the intermediate step in the PCI
> > patch would not be needed.
>
> It's easiest if Jesse takes them both, here is my ACK:
>
> Acked-by: David S. Miller <davem@davemloft.net>

Applied to my linux-next tree.  Thanks.

Jesse
