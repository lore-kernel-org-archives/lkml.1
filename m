Return-Path: <linux-kernel-owner+w=401wt.eu-S939264AbXG3Q6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939264AbXG3Q6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936408AbXG3Q6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:58:33 -0400
Received: from CPE0050fc332afc-CM00407b861c34.cpe.net.cable.rogers.com ([74.120.60.167]:53454
	"EHLO nk-1124.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764437AbXG3Q6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:58:32 -0400
Message-ID: <46AE18AE.50305@tigershaunt.com>
Date: Mon, 30 Jul 2007 12:58:22 -0400
From: Rashkae <rashkae@tigershaunt.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060913)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Matthew Hawkins <darthmdh@gmail.com>, ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>	<1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>	<930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>	<20070729204716.GB1578@elte.hu>	<930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>	<20070730114649.GB19186@elte.hu> <op.tv90xghwatcbto@linux.site>	<d3380cee0707300831m33d896aufcbdb188576940a2@mail.gmail.com>	<b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com> <1185814243.7377.2.camel@localhost>
In-Reply-To: <1185814243.7377.2.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:

> 
> Do we care ? The code should be replaced with ptep_get_and_clear +
> pte_modify anyway..
> 

Since the general direction of this thread was for people to test 3D 
game performance with the shiny new CFS cpu scheduler, I would say yes, 
we do care if people with the only 2 types of gaming caliber Video cards 
can get said video cards working, right now, with said shiny new kernel.

Yes yes, I know, kernel devs don't care if they break binary drivers... 
and in principle, I agree with that philosophy.. but it's still damn 
inconvenient at times :)
