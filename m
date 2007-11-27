Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbXK0Qph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbXK0Qph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXK0Qp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:45:29 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:49362 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbXK0Qp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:45:29 -0500
Date: Tue, 27 Nov 2007 11:45:27 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Frans Pop <elendil@planet.nl>
Cc: parisc-linux@lists.parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [parisc] 2.6.24-rc3 (64-bit, smp) fails to boot on 9000/785/J5600
Message-ID: <20071127164527.GA28891@fattire.cabal.ca>
References: <200711271026.34863.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711271026.34863.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 10:26:34AM +0100, Frans Pop wrote:
> v2.6.24-rc3-19-g2ffbb83 fails very early in the boot procedure.
> 2.6.23 compiled with similar config boots fine.
> 
> System is running Debian unstable; kernel was compiled using gcc 4.1.2.
> 

Ah, I diagnosed this last week. Will post the patch in a bit.
