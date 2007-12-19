Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbXLSBOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbXLSBOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXLSBOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:14:25 -0500
Received: from are.twiddle.net ([64.81.246.98]:46263 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbXLSBOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:14:24 -0500
Date: Tue, 18 Dec 2007 17:12:10 -0800
From: Richard Henderson <rth@twiddle.net>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071219011210.GA25738@twiddle.net>
Mail-Followup-To: Chuck Ebbert <cebbert@redhat.com>,
	Robert Hancock <hancockr@shaw.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
	Keith Packard <keithp@keithp.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <fa.WmGIH8th8MfmciABVSBi6whxeFE@ifi.uio.no> <fa.Obg5E3fyax+MaF94//uo40q/Zyk@ifi.uio.no> <fa./6K5nXEIpws4VU8HtJhQjF4AoGg@ifi.uio.no> <fa.V82IIxMkW3eu+9B44NfoyYYQDP4@ifi.uio.no> <fa.DM9AyNQQtam66XpKVeXeqS639os@ifi.uio.no> <fa.f5O3U527Rv8DNk05hDFRjdCaeFE@ifi.uio.no> <47686197.6080807@shaw.ca> <47686C09.1070602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47686C09.1070602@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 07:55:37PM -0500, Chuck Ebbert wrote:
> You can boot with "pci=mmconf" to enable it.

Heh.

PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.


r~
