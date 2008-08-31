Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYHaTwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYHaTwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758907AbYHaTv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:51:56 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:38760 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660AbYHaTvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:51:55 -0400
Message-ID: <48BAF65B.708@opengridcomputing.com>
Date: Sun, 31 Aug 2008 14:51:55 -0500
From: Tom Tucker <tom@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
References: <1219605422.14389.2.camel@localhost>	 <1219605596.14389.5.camel@localhost>	 <1219615789.27921.152.camel@localhost.localdomain>	 <1219616136.14389.12.camel@localhost>	 <48B2D7F8.5020206@opengridcomputing.com>	 <20080826192711.GJ4380@fieldses.org>	 <48B567F5.2090605@opengridcomputing.com>	 <1220111261.31172.14.camel@localhost.localdomain>	 <20080831193037.GB14876@fieldses.org>	 <1220211842.31172.18.camel@localhost.localdomain>	 <20080831194609.GC14876@fieldses.org> <1220212153.31172.21.camel@localhost.localdomain>
In-Reply-To: <1220212153.31172.21.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Sun, 2008-08-31 at 15:46 -0400, J. Bruce Fields wrote:
>> Yes.  It's the server side we're interested in, by the way--are you
>> collecting this deubgging on the client?
> 
> Er, yeah, since the client appeared to be the problem.
> 
> I'll try again on the server!
>

Thanks Ian,

Tom

> Ian.

