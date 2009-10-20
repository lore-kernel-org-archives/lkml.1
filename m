Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbZJTVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbZJTVNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZJTVNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:13:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZJTVNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:13:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SH4aobEky87xLAOQFi0YFOHnJ9tyRaE2koZvupcjlRrirPOyPLeXKUL4QhNZ3qYvq
	bFlCtW0Xd9q60M+q5HC9w==
Date: Tue, 20 Oct 2009 14:13:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 5/5] Documentation: ABI: document
 /sys/devices/system/cpu/
In-Reply-To: <20091020204738.GC23675@ldl.fc.hp.com>
Message-ID: <alpine.DEB.1.00.0910201410280.27248@chino.kir.corp.google.com>
References: <20091019212740.32729.7171.stgit@bob.kio> <20091019213435.32729.81751.stgit@bob.kio> <alpine.DEB.1.00.0910192022460.25264@chino.kir.corp.google.com> <20091020204738.GC23675@ldl.fc.hp.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009, Alex Chiang wrote:

> > Would it be possible for you to document all entities in 
> > /sys/devices/system/cpu/* in this new file (requiring a folding of 
> > Documentation/ABI/testing/sysfs-devices-cache_disable into it)?
>  
> I'll give it a go. There are quite a few things in that directory
> though, like topology information, frequency, etc. that I wasn't
> so excited about documenting.
> 

Those are usually the ones where documentation is the most valuable and 
I'm sure would be greatly appreciated.

> But if that's the tax to create my new symlinks, I'll pay it. ;)
> 

It's definitely not required, I just thought it was a good opportunity to 
document all the contents under /sys/devices/system/cpu if you're going to 
do some of them.  It's up to you.
