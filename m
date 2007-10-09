Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbXJILZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbXJILZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXJILZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:25:17 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:51255 "EHLO
	viefep23-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496AbXJILZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:25:15 -0400
Subject: Re: Patch for WindowsMobile5 on Linux Kernel
From: Thomas Sailer <t.sailer@alumni.ethz.ch>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Bernd Petrovitsch <bernd@firmix.at>, "Grosjo.net - jom" <jom@grosjo.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1191922629.10146.28.camel@frg-rhel40-em64t-04>
References: <470B47D9.30406@grosjo.net>
	 <1191922365.5559.1.camel@tara.firmix.at>
	 <1191922629.10146.28.camel@frg-rhel40-em64t-04>
Content-Type: text/plain
Organization: e-vision, inc.
Date: Tue, 09 Oct 2007 13:25:03 +0200
Message-Id: <1191929103.10858.59.camel@xbox360>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 11:37 +0200, Xavier Bestel wrote:

> FWIW, the patch in question is a one-liner:

That's not a valid argument. This may work with a WM5 device, but looks
very dubious, wrt. other RNDIS devices. Why are these constants
hardcoded and not taken in some way from the descriptors?

There must be some justification why these values need to be hardcoded,
and if so, this must be dependent on the rndis device really being a WM5
device.

Nacked-By: Thomas Sailer <t.sailer@alumni.ethz.ch>


