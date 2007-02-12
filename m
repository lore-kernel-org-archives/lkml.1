Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXBLI5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXBLI5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964789AbXBLI5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:57:45 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:25606
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964784AbXBLI5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:57:44 -0500
Message-Id: <45D03A3F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Feb 2007 08:58:23 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: <tony.luck@intel.com>, "Christoph Hellwig" <hch@lst.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
References: <200702070759.l177xIti030295@hera.kernel.org>
 <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de>
 <45D025BF.76E4.0078.0@novell.com>
 <1171268065.6308.0.camel@laptopd505.fenrus.org>
In-Reply-To: <1171268065.6308.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > If Jan actually had a goal with that except making the code utterly
>> > unreadable he should try again with small patches that are well
>> > explained and do one thing at a at time.  (And cane be reviewed an
>> > improved on if needed.
>> 
>> As the topic says - the goal is to support Xen. 
>
>Xen the linux guest
>or
>Xen the hypervisor?
>
>if it's the later, why on earth would we want to uglyfy linux for it?
>(arguably it holds in the former case as well)

The former.

Jan


