Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZJKNPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZJKNPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 09:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbZJKNPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 09:15:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36965 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757188AbZJKNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 09:15:53 -0400
Date: Sun, 11 Oct 2009 14:16:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: VT6421 problems with sata_via
Message-ID: <20091011141638.616084c0@lxorguk.ukuu.org.uk>
In-Reply-To: <71cd59b00910110254q2e5318cfw30ac0a4f86770487@mail.gmail.com>
References: <71cd59b00910110254q2e5318cfw30ac0a4f86770487@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 11:54:49 +0200
Corentin Chary <corentin.chary@gmail.com> wrote:

> Hi,
> I recently needed some more space and bought a Deskstar 7K1000.B for my server.
> The motherboard is old, and did not have SATA port, so I added a
> VT6421 PCI SATA controller.

Lots of 6421 setups do not work on Linux full stop. I've asked VIA
several times for the relevant data sheet/info to fix this and they've
never done more than acknowledge receipt of the mail.

Alan
