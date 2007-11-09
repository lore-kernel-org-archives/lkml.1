Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbXKIQ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbXKIQ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXKIQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:59:10 -0500
Received: from xenotime.net ([66.160.160.81]:56181 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754103AbXKIQ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:59:09 -0500
Date: Fri, 9 Nov 2007 08:59:05 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: GRUB reports "Setup signature not found"
Message-Id: <20071109085905.3c2a78cd.rdunlap@xenotime.net>
In-Reply-To: <47348F54.2080507@redhat.com>
References: <47348F54.2080507@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 11:48:20 -0500 Chuck Ebbert wrote:

> Multiple people have now reported this error message with 2.6.23.
> Updating GRUB fixes it:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=370391
> https://bugzilla.redhat.com/show_bug.cgi?id=371321

Thanks for the info.
A better fix IMHO would be if one could get lilo to work.  :)

---
~Randy [who is fed up with grub]
