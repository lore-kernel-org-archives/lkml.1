Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZLCXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZLCXAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZLCXA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:00:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbZLCXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:00:27 -0500
Date: Thu, 3 Dec 2009 15:00:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: convert to seq_file
Message-Id: <20091203150001.b017c2f1.akpm@linux-foundation.org>
In-Reply-To: <20091203172609.GA16463@khazad-dum.debian.net>
References: <20091125071642.GD3459@x200.malnet.ru>
	<20091203172609.GA16463@khazad-dum.debian.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 15:26:09 -0200
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> Alexey,  I like your patch, but it pretty much clashes with lots of stuff in
> my patch queue.
> 
> I think the easiest way is for me to take in your patch, place it at the end
> of the queue, and update it when I get to it.
> 
> I won't promise I will be able to merge it for 2.6.33, but I can promise I
> will do it for 2.6.34.  Depends how fast I can get the higher priority stuff
> out of the door.

Your patch queue isn't in linux-next :(

Can we fix that?
