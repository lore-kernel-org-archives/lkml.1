Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYGJQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYGJQgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYGJQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:36:12 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:54425 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYGJQgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:36:11 -0400
Date: Thu, 10 Jul 2008 18:40:08 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Message-ID: <20080710164008.GD14476@datenfreihafen.org>
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com> <20080707200251.GA3449@datenfreihafen.org> <48730DE2.2050302@gmail.com> <4873734F.4030808@gmail.com> <20080708203213.GF18479@datenfreihafen.org> <20080710162158.GG10441@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710162158.GG10441@flint.arm.linux.org.uk>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
	phones
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Thu, 2008-07-10 at 17:21, Russell King - ARM Linux wrote:
> On Tue, Jul 08, 2008 at 10:32:13PM +0200, Stefan Schmidt wrote:
> > Daniel fixed all of Philipps comments besides the voltage framework. From Eric
> > comments we updated to the new IRQ part and moved to platform data.
> 
> Due to the problems people were seeing with the IRQ numbering commit, we
> (Eric and myself) have decided to drop that commit for the time being.
> It will reappear after this merge window however.

Thanks for the note.I just run into it while testing your updated tree with our
remaining patches. I remove this for now and will switch back to it when the
dust has settled and it is back.

regards
Stefan Schmidt
