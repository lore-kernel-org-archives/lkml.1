Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbZCaPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbZCaPxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZCaPxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:53:22 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:53323 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZCaPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:53:21 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Mark Williamson <mark.williamson@cl.cam.ac.uk>
To: Xavier Bestel <xavier.bestel@free.fr>
Subject: Re: Replacing VFAT as filesystem on removeable media
Date: Tue, 31 Mar 2009 16:53:12 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, info@fsf.org, office@fsfeurope.org,
       info@linuxfoundation.org
References: <200903311015.29222.Martin@Lichtvoll.de> <200903311602.41272.mark.williamson@cl.cam.ac.uk> <1238512897.27596.579.camel@skunk>
In-Reply-To: <1238512897.27596.579.camel@skunk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311653.14500.mark.williamson@cl.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 16:21:37 Xavier Bestel wrote:
> I'm speaking out of my ass here, but seeing how Microsoft managed to
> sneak some patents into something as trivial as FAT, I'm pretty sure MTP
> is a hell of a minefield.

That did occur to me too but I was somewhat hopeful that perhaps this would be 
mitigated by the (eventual?) adoption as a usb.org standard.

The spec and an adopters' legal agreement around it is here:
http://www.usb.org/developers/devclass_docs/MTP_1.0.zip

I scanned the agreement and it didn't look like it was obviously evil but I'm 
not really qualified to make that judgement ;-)  It had some promising words in 
it like "zero royalty" but I would be much happier if someone with legal 
knowhow (and preferably experience of the usb.org standards procedures) 
decoded it for me / us!

Assuming the spec is legally "safe" to implement, I would have thought it 
would be generally beneficial for device manufacturers to support both 
"initiator" and "responder" endpoints under Linux.

Cheers,
Mark
