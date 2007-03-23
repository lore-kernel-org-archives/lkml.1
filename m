Return-Path: <linux-kernel-owner+w=401wt.eu-S2992609AbXCWWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992609AbXCWWrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992607AbXCWWrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:47:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992599AbXCWWre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:47:34 -0400
Message-ID: <460458FE.4010704@redhat.com>
Date: Fri, 23 Mar 2007 18:47:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>	<20070323112411.f6a8a762.randy.dunlap@oracle.com>	<20070323200819.4e734f4f@lxorguk.ukuu.org.uk>	<20070323130315.7ed48121.randy.dunlap@oracle.com> <20070323214704.1e8d5463@lxorguk.ukuu.org.uk>
In-Reply-To: <20070323214704.1e8d5463@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>> What is 0x40?  can it be #defined (or enum-ed) instead of a magic
>>>> value?  please?  (more of same below)
>>> It's 0x40. Its a "command dependant bit" - no useful name.
>> dependent.  OK, thanks.
> 
> IDE is a bit like that. I'm amazed some of the command flags arent in
> latin.
> 

Hmm, what's latin for "no useful name?" You could call it that.

