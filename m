Return-Path: <linux-kernel-owner+w=401wt.eu-S1764570AbZAOLPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764570AbZAOLPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZAOLOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:14:55 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbZAOLOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:14:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=PJ9MElt0cmNBgc9i0x7ME5vPnAeVp3zyiLZe4wDItHr9uYuErXlRCETDXJZpVu+QK
	1dTZyr0cWfESV4tGIEDDg==
Date: Thu, 15 Jan 2009 03:13:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: linux-kernel@vger.kernel.org, Bryan Donlan <bdonlan@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Matthias Andree <matthias.andree@gmx.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [take4] OOM documentation update [was: Linux killed Kenny,
 bastard!]
In-Reply-To: <20090115085703.GD29586@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901150312580.22802@chino.kir.corp.google.com>
References: <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net> <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
 <20090114161225.GA9584@ioremap.net> <20090114170606.GB12102@ioremap.net> <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com> <20090114221420.GB6039@ioremap.net> <alpine.DEB.2.00.0901141655390.22699@chino.kir.corp.google.com>
 <20090115085703.GD29586@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Evgeniy Polyakov wrote:

> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> 

Acked-by: David Rientjes <rientjes@google.com>
