Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZF0End@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZF0End (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZF0EnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:43:23 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40284 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZF0EnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:43:23 -0400
Date: Fri, 26 Jun 2009 22:43:25 -0600
From: Alex Chiang <achiang@hp.com>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [BUG] GM45 blanks shortly after boot in 2.6.30-git
Message-ID: <20090627044325.GA5086@ldl.fc.hp.com>
References: <4A43359F.3030208@anarazel.de> <4A459D85.2080008@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A459D85.2080008@anarazel.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andres Freund <andres@anarazel.de>:
> I have not yet had access to another computer (so no trace yet) but I  
> bisected it to this very innocent looking commit:
> 1e4cffe78e1decd937c7b78410eec87da6b87954 : ACPI: video: convert to  
> acpi_get_pci_dev

This has already been fixed in Linus's tree. Can you pull the
latest and try again?

Sorry for the inconvenience.

/ac

