Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZEJFi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZEJFi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 01:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZEJFiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 01:38:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbZEJFiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 01:38:50 -0400
Date: Sat, 9 May 2009 22:34:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-Id: <20090509223454.4642753d.akpm@linux-foundation.org>
In-Reply-To: <20090509161923.GA942@suse.de>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 09:19:23 -0700 Greg KH <gregkh@suse.de> wrote:

>  We need to be able to support large number of partitions at boot
> time. 

I suspect that the intersection between (systems which need to shave
boot time to the minimum) and (systems which have lots of partitions)
is quite small?

