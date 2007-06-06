Return-Path: <linux-kernel-owner+w=401wt.eu-S934043AbXFFA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbXFFA0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933081AbXFFA0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:26:23 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46259 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763448AbXFFA0X (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:26:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeff Garzik <jeff@garzik.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       hch@infradead.org, mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
In-Reply-To: Your message of "Tue, 05 Jun 2007 18:16:25 EDT."
             <20070605221625.GU31565@havoc.gtf.org>
From: Valdis.Kletnieks@vt.edu
References: <20070605151104.GG31565@havoc.gtf.org> <20070605151847.GD2572@flint.arm.linux.org.uk> <20070605152133.GE2572@flint.arm.linux.org.uk> <20070605.122745.118950378.davem@davemloft.net> <20070605212523.GB18027@flint.arm.linux.org.uk> <20070605213815.GA19648@flint.arm.linux.org.uk> <20070605214830.GS31565@havoc.gtf.org> <20070605220345.GA22705@flint.arm.linux.org.uk>
            <20070605221625.GU31565@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181089515_19483P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jun 2007 20:25:15 -0400
Message-ID: <20436.1181089515@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181089515_19483P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Jun 2007 18:16:25 EDT, Jeff Garzik said:
> On Tue, Jun 05, 2007 at 11:03:45PM +0100, Russell King wrote:
> > And rather than configuring your MUA to ignore the header...
> 
> > You're using mutt, mutt can be configured so.
> 
> So, you are seriously proposing that EVERYONE reconfigure their MUA,
> because you are sending out bad headers?
> 
> Don't you think that is an unscalable solution, and an imposition?

Not only is it unscalable, it almost by definition is anti-social.  The only
times I've actually seen one in the wild, it's because some subscriber to a
mailing list wishes to subvert the list's culture in a manner worse than
a Reply-To: header.  I considered adding support for Mail-Followup-To: to
the exmh MUA, but decided against it, because it would basically mean that
every time I got one, I'd have to curse and moan and put the To: and cc: back
the way everybody *else* on the list wanted those to headers to behave. Kind
of hard to motivate myself to write Tk/Tcl code that will just mean a *worse*
user experience for myself...

--==_Exmh_1181089515_19483P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGZf7rcC3lWbTT17ARAlSMAJ452BV78rAKNiZbsVUiy2jwE2CviACg5b2G
yzSuDJ1ajBujwEyGgjUeyj8=
=Sz4C
-----END PGP SIGNATURE-----

--==_Exmh_1181089515_19483P--
