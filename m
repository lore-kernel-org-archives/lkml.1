Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbXHVJm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbXHVJm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXHVJmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:42:10 -0400
Received: from outbound.mailhop.org ([63.208.196.171]:3699 "EHLO
	outbound.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbXHVJmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:42:08 -0400
X-Greylist: delayed 12412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 05:42:08 EDT
X-MHO-User: U2FsdGVkX1+FoZAbzdW8Y3nsgFSl51df
X-MHO-User: U2FsdGVkX1/4XKM690EG5Y5I/wYXPCPQ
X-MHO-User: U2FsdGVkX19fTaM0ZL+1aYyDoUn1uX9R
X-MHO-User: U2FsdGVkX19fm1GZDXOO6Bva+YZ1v4u1
X-MHO-User: U2FsdGVkX1+ay8NUI6Vic9KC9yd4u1Es
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 80.36.218.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Mac305ba4OgAJnfJyNarF
Date: Wed, 22 Aug 2007 08:15:08 +0200
From: Kiko Piris <kernel@pirispons.net>
To: Rene Herman <rene.herman@gmail.com>
Cc: =?iso-8859-1?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= <jopan@alumni.uv.es>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Problems with IDE on linux 2.6.22.X
Message-ID: <20070822061508.GA16152@bacterio.pirispons.net>
Mail-Followup-To: Rene Herman <rene.herman@gmail.com>,
	=?iso-8859-1?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= <jopan@alumni.uv.es>,
	linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
	linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200708212149.12912.jopan@alumni.uv.es> <46CB626F.8020801@gmail.com> <200708220339.45138.jopan@alumni.uv.es> <46CBA0F0.70503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46CBA0F0.70503@gmail.com>
User-Agent: Mutt
X-No-CC: Please respect my Mail-Followup-To header
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/2007 at 04:35 +0200, Rene Herman wrote:

> The old SATA driver available from the IDE menu also does not support your 
> chip, so I don't believe there are any workarounds -- you'll need the issue 
> fixed.

I had the same issue when I compiled 2.6.22 on my T60 (SATA_AHCI drives
my hd). I workarounded it selecting IDE_GENERIC as a module.

Worth a try…

-- 
Kiko
Private mail is preferred encrypted:
http://www.pirispons.net/pgpkey.html
