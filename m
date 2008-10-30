Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYJ3QgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYJ3QgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJ3Qf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:35:58 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:62353 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbYJ3Qf5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:35:57 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: "Yang, Libin" <Libin.Yang@amd.com>
Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Date: Thu, 30 Oct 2008 17:35:54 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.27.4r4; KDE/4.1.71; x86_64; ; )
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Huang, Shane" <Shane.Huang@amd.com>
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de> <20081030055410.GB19035@kroah.com> <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810301735.55108.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag 30 Oktober 2008, Yang, Libin wrote:
> Thanks for reporting this bug. We are trying to reproduce this bug and
> will look into it.

btw, it is not only enclosures, I have a multi-card reader that shows the same 
misbehaviour. Connect it with a sd card - and mouse freezes  so fast I can't 
even start to copy stuff.

Glück Auf,
Volker
