Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbXJOT4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbXJOT4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933369AbXJOTzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:55:13 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1417 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbXJOTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:55:08 -0400
Date: Mon, 15 Oct 2007 21:54:28 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mark Gross <mgross@linux.intel.com>, Rik van Riel <riel@surriel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015195428.GF25076@vanheusden.com>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com> <20071015191732.GA1841@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015191732.GA1841@martell.zuzino.mipt.ru>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sun Oct 14 00:32:21 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > http://kernelnewbies.org/KernelProjects
> > 
> > Is there already a make config option that will do a good job at setting
> > a default .config file based on what is already running on a system?  
> > 
> > I get tiered of trimming down my .config for my laptop build so it takes
> > less than 30min to build a kernel.
> 
> Ehh? You do it once, then leave it aside or in /proc/config.gz, on new
> kernel copy it back, "make oldconfig", answer several questions and here
> we go.

Ah yes, but then you buy a new system to which the old config does not
apply.


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
