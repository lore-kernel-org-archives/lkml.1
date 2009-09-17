Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZIQPfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZIQPfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZIQPfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:35:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZIQPfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:35:21 -0400
Message-ID: <4AB25736.1060601@suse.de>
Date: Fri, 18 Sep 2009 00:35:18 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca>
In-Reply-To: <4AB239C8.2020203@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mark Lord wrote:
> Tejun.. do we do a FLUSH CACHE before issuing a non-NCQ command ?

Nope.

> If not, then I think we may need to add code to do it.

Hmm... can you explain a bit more?  That seems rather extreme to me.

Thanks.

-- 
tejun
