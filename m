Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXIFIcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXIFIcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 04:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbXIFIb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 04:31:59 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:33975 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbXIFIb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 04:31:58 -0400
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
References: <20070903081736.288288000@amd.com>
	<20070903013157.72c94891@laptopd505.fenrus.org>
	<20070903091718.GB22144@alberich.amd.com>
	<20070903043319.7573875b@laptopd505.fenrus.org>
	<20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
	<20070905084427.GE6409@erda.amd.com> <46DE80F0.4000706@zytor.com>
	<kjmd4wxz822.fsf@pelargir.dolphinics.no>
	<20070905161300.GE22086@alberich.amd.com>
	<86802c440709051542w1950e28bhb21cf5c380527a6e@mail.gmail.com>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Thu, 06 Sep 2007 10:31:59 +0200
In-Reply-To: <86802c440709051542w1950e28bhb21cf5c380527a6e@mail.gmail.com> (Yinghai Lu's message of "Wed\, 5 Sep 2007 15\:42\:31 -0700")
Message-ID: <kjmps0w9ou8.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> mmconfig is set in NB ( in new CPU), Do we still need to set mmconfig
> in SB like mcp55?

I wasn't aware that the family 10h-chips had MSRs for setting the
mmconfig address space directly in the NB (core?).  Please disregard
my previous comment...

-- 
								Arne.
