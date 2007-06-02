Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbXFBOX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbXFBOX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbXFBOXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:23:50 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:38977 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbXFBOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:23:48 -0400
Date: Sat, 2 Jun 2007 15:23:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Hughes <hughsient@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bastien Nocera <hadess@hadess.net>, John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Message-ID: <20070602142333.GA3452@srcf.ucam.org>
References: <1180614979.2693.26.camel@localhost.localdomain> <1180615994.3030.166.camel@cookie.hadess.net> <1180619002.2693.35.camel@localhost.localdomain> <1180626416.3469.7.camel@localhost.localdomain> <d120d5000706010945w4de3e8d9i4d43d2ae686e4d0a@mail.gmail.com> <1180788652.2355.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180788652.2355.27.camel@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Add INPUT support to toshiba_acpi
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 01:50:52PM +0100, Richard Hughes wrote:
> > KEY_SCREENLOCK? KEY_SCREENSAVER?
> 
> Either of these keys would be good to add.

We've been interpreting "KEY_COFFEE" as screenlock (as in "I've gone for 
a coffee break, lock the screen").

-- 
Matthew Garrett | mjg59@srcf.ucam.org
