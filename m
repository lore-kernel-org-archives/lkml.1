Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYIVPjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYIVPjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYIVPjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:39:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45993 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYIVPjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:39:01 -0400
Date: Mon, 22 Sep 2008 08:38:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc6 BUG: unable to handle kernel paging request
Message-Id: <20080922083855.b731aff0.randy.dunlap@oracle.com>
In-Reply-To: <48D03A76.10907@gmail.com>
References: <48D03A76.10907@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 16:00:06 -0700 John Daiker wrote:

> No idea what caused this, but that shall be left for more clever minds 
> than I.
> 
> x86_64, SMP, 4GB Ram, Gigabyte 965p-ds3
> 
> Attached:
> kernel config
> kernel oops
> 
> Website: 'objdump -d vmlinux' of vmlinux in question.
> http://johndaiker.com/kernel/vmlinux.dump  (9 MB tar.gz)

i.e., filename is http://johndaiker.com/kernel/vmlinux.dump.tar.gz


---
~Randy
