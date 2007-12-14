Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXLNCmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXLNCmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXLNCmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:42:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:58557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbXLNCmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:42:07 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
Date: Thu, 13 Dec 2007 21:41:23 -0500
User-Agent: KMail/1.9.5
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20071127150557.GA4365@ics.muni.cz> <20071128041155.GB18131@khazad-dum.debian.net> <20071128083153.GL4365@ics.muni.cz>
In-Reply-To: <20071128083153.GL4365@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712132141.23656.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 03:31, Lukas Hejtmanek wrote:
> On Wed, Nov 28, 2007 at 02:11:55AM -0200, Henrique de Moraes Holschuh wrote:
> > On Tue, 27 Nov 2007, Rafael J. Wysocki wrote:
> > > > in recent kernel, I got the following warnings while booting. It's ACPI
> > > > related. Does anybode care? Lenovo ThinkPad T61 (6465CTO).
> > 
> > Could we know the BIOS version, please?
> 
> 7LET56WW (1.26 ) (according to hal, 1.26 is definitely correct, can be seen in
> BIOS as well)

I've udpated the BIOS on my T61 to 1.26 to match yours, but
running 2.6.24-rc5 I don't see the issue you reported.

If it still fails for you, please send me your .config

thanks,
-Len
