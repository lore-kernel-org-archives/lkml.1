Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYHHVsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYHHVsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYHHVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:48:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:42268 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbYHHVsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:48:45 -0400
Date: Sat, 9 Aug 2008 07:48:05 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
In-Reply-To: <1218214935.3146.5.camel@dhcppc0>
Message-ID: <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org>
References: <1218214935.3146.5.camel@dhcppc0>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Thomas Meyer wrote:

> Hi.
> 
> Beginning with next-20080808 after letting the system run for 5 minutes
> or so, I get an error from the fork call, e.g.:
> 
> "bash: fork: Resource temporarily unavailable"
> 
> Doing an "echo c > /proc/sysrq-trigger" I was able to get an vmcore dump
> of the running kernel using the kdump mechanism.
> 
> what should i do next?

Which distro and version are you using?  Please post your .config file.


-- 
James Morris
<jmorris@namei.org>
