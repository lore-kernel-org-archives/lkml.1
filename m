Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbZFPWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbZFPWel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbZFPWed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:34:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbZFPWec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:34:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] IDE: consistently use type bool for wake enable variable
Date: Wed, 17 Jun 2009 00:35:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090616142554.7bce02f6@jbarnes-g45> <200906170016.16716.elendil@planet.nl> <20090616151804.0ea89caa@jbarnes-g45>
In-Reply-To: <20090616151804.0ea89caa@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906170035.11644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 June 2009, Jesse Barnes wrote:
> On Wed, 17 Jun 2009 00:16:15 +0200
> Frans Pop <elendil@planet.nl> wrote:
> 
> > IDE: consistently use type bool for wake enable parameter
> > 
> > Other functions use type bool, so use that for pci_enable_wake as
> > well.
> > 
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> > ---
> > 
> > Hi Jesse,
> > 
> > I've had this trivial patch sitting in my local branch for some time.
> > Please consider including.
> 
> Yep, looks reasonable.  Rafael I assume there's no objection here?

Sure, please feel free add my ACK to the patch.

Best,
Rafael
