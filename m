Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZJYIjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZJYIjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZJYIjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:39:23 -0400
Received: from isilmar.linta.de ([213.133.102.198]:49166 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752360AbZJYIjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:39:22 -0400
Date: Sun, 25 Oct 2009 09:38:41 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stefani Seibold <stefani@seibold.net>
Cc: Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PCI Express-to-PCI Bridge: yenta_cardbus  no bus associated!
Message-ID: <20091025083841.GA12526@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Stefani Seibold <stefani@seibold.net>,
	Matthew Wilcox <matthew@wil.cx>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1254248605.8881.1.camel@wall-e> <200909300115.54263.rjw@sisk.pl> <1256393003.9013.4.camel@wall-e> <20091024203452.GA10555@parisc-linux.org> <1256458229.4026.1.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256458229.4026.1.camel@wall-e>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, Oct 25, 2009 at 09:10:29AM +0100, Stefani Seibold wrote:
> Am Samstag, den 24.10.2009, 14:34 -0600 schrieb Matthew Wilcox:
> > On Sat, Oct 24, 2009 at 04:03:23PM +0200, Stefani Seibold wrote:
> > > If you need further information or dumps please contact me.
> > > 
> > > The kernel parameter 'pci=assign-busses' did not fix the problem.
> > 
> > What does dmesg say when you specify pci=assign-busses?
> > 
> 
> Okay, i tried it again with 'pci=assign-bussed'. All i get is a
> 
> decode_hpp: Could not get hotplug parameters. Use defaults
> 
> thats all. The express-card will not be detected.

I assume the "d" at the end was just a typo -- and "lspci -vvv" looks the
same?

Best,
	Dominik
