Return-Path: <linux-kernel-owner+w=401wt.eu-S1765028AbXHNQVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765028AbXHNQVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbXHNQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:21:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:60827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761684AbXHNQVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:21:14 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Norbert Preining <preining@logic.at>
Subject: Re: [Fwd: Re: 2.6.23-rc3 regression and bisection query]
Date: Tue, 14 Aug 2007 12:18:18 -0400
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Sergey Dolgov <solkaa@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com> <46C0D35B.5030104@suse.de> <20070814070917.GA21301@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070814070917.GA21301@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141218.18697.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2007 03:09, Norbert Preining wrote:

> But there is still the strange thing that
> 	ACPI: Battery Slot [BAT1] (battery absent)
> is present in the dmesg, while 
> 	$ acpi
> 	     Battery 1: charging, 46%, 00:00:49 until charged

Does the system support more than 1 battery?
Can you show the full dmesg and the full contents of /proc/acpi/battery/*/*?

thanks,
-Len
