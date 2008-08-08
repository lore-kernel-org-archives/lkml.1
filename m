Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbYHHWzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbYHHWzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYHHWyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:54:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:51096 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbYHHWyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:54:52 -0400
Date: Sat, 9 Aug 2008 08:48:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Thomas Meyer <thomas@m3y3r.de>, Adrian Bunk <bunk@kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
In-Reply-To: <17923.1218234735@redhat.com>
Message-ID: <alpine.LRH.1.10.0808090847530.29741@tundra.namei.org>
References: <20080808172141.GY14495@cs181140183.pp.htv.fi> <1218214935.3146.5.camel@dhcppc0> <17923.1218234735@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, David Howells wrote:

> 
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > The only commits that touched kernel/fork.c between next-20080807 and 
> > next-20080808 are David's CRED patches.
> > 
> > David, can you look at this?
> 
> I can, but I'll need a config file as it boots fine for me and passes the LTP
> testsuites I've run on it.

Is this with linux-next or my tree?

(I'm currently building next-20080808 & will do some testing).


-- 
James Morris
<jmorris@namei.org>
