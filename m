Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZAEKvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZAEKvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZAEKvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:51:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:34211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZAEKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:51:10 -0500
Date: Mon, 5 Jan 2009 02:53:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: ncunningham-lkml@crca.org.au
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090105025300.3afbec23@infradead.org>
In-Reply-To: <1231135294.8179.45.camel@nigel-laptop>
References: <20090104092430.7ffd2c41@infradead.org>
	<1231135294.8179.45.camel@nigel-laptop>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 17:01:34 +1100
Nigel Cunningham <ncunningham-lkml@crca.org.au> wrote:

> Hi Arjan.
> 
> Great work, and valuable too. I'm just wondering if the header file
> name "async.h" is a little too generic? Something like async_init.h
> perhaps?
> 

while the users I have in mind are during init, the concept and
infrastructure of asynchronous function calls is by no means limited to
that use case... I hope there are many other uses for this :)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
