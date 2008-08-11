Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYHKA1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYHKA1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYHKA1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:27:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:38187 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYHKA1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:27:12 -0400
Date: Mon, 11 Aug 2008 10:26:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Grant Wilson <grant.wilson@zen.co.uk>,
       Jasper Bryant-Greene <jasper@amiton.co.nz>,
       Thomas Meyer <thomas@m3y3r.de>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
In-Reply-To: <13299.1218367912@redhat.com>
Message-ID: <alpine.LRH.1.10.0808111026090.3809@tundra.namei.org>
References: <20080810113044.19143b0a@worthy.swandive.local> <1218322518.3268.0.camel@luna.unix.geek.nz> <1218287473.3155.13.camel@dhcppc0> <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org>
 <14476.1218286327@redhat.com> <15386.1218290826@redhat.com> <10251.1218361539@redhat.com>  <13299.1218367912@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008, David Howells wrote:

> Okay.  That's useful, thanks.  That indicates that my accounting of user
> processes is incorrect somewhere.  This won't show up when running as a
> privileged user only.

I'm seeing this also now when running X (previously was not).


-- 
James Morris
<jmorris@namei.org>
