Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbZDBAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbZDBAnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZDBAnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:43:03 -0400
Received: from ozlabs.org ([203.10.76.45]:44154 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZDBAnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:43:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.29 boot hang
Date: Thu, 2 Apr 2009 11:12:57 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       andreas.herrmann3@amd.com, Andrew Morton <akpm@linux-foundation.org>
References: <49D280EF.1080507@oracle.com> <200904011703.58179.rusty@rustcorp.com.au> <49D3A4B6.2030409@oracle.com>
In-Reply-To: <49D3A4B6.2030409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021112.57662.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009 04:00:30 Randy Dunlap wrote:
> 2.6.29 + this patch still hang during boot for me.  Same symptoms.

OK, thanks.  It's something new then.

We're down to inserting printks at this point.  Can you send me your
.config so I can try to reproduce it on my AMD box here?

(I'm assuming that the latest Linus tree still doesn't boot, so it's not
some incidental issue).

Thanks,
Rusty.
