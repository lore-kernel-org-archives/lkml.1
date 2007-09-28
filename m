Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXI1GKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXI1GKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXI1GKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:10:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55757 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbXI1GKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:10:12 -0400
Message-ID: <46FC9B68.7010205@bull.net>
Date: Fri, 28 Sep 2007 08:12:56 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm1 0/2]  Fix unlocked call to idr_find()
References: <20070927143354.663489000@bull.net> <20070928055256.GA1767@ff.dom.local>
In-Reply-To: <20070928055256.GA1767@ff.dom.local>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 08:13:11,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 08:13:13,
	Serialize complete at 28/09/2007 08:13:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Thu, Sep 27, 2007 at 04:33:54PM +0200, Nadia.Derbey@bull.net wrote:
> 
>>This a series of 2 patches that should be applied on top of the other ipc
>>patches, in 2.6.23-rc6-mm1.
> 
> ...
> 
>>They should be applied to 2.6.23-rc6-mm1, in the following order:
> 
> 
> Didn't you mean 2.6.23-rc8-mm1, btw?
> 
> Regards,
> Jarek P.
> 

No, what I wrote is exactly what I meant: unfortunately I couldn't get 
the rc8-mm1 yet.
But, Before building the patch, I applied the ipc patches that had been 
integrated in rc7-mm1.
Nothing happened in rc8-mm1.
So you should have no problem appying these patches to your rc8-mm1 tree.

Regards,
Nadia
