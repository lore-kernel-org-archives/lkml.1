Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXJLSGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXJLSGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXJLSGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:06:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbXJLSGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:06:24 -0400
Date: Fri, 12 Oct 2007 11:06:07 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: USB subsystem merge plans
Message-Id: <20071012110607.17ee9028.zaitcev@redhat.com>
In-Reply-To: <200710121457.29357.oliver@neukum.org>
References: <470F6C57.4020108@kingswood-consulting.co.uk>
	<200710121457.29357.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 14:57:28 +0200, Oliver Neukum <oliver@neukum.org> wrote:

> > Should I be submitting my driver as a patch to linux.kernel or are Alan 
> > or Greg going to push their changes?
> 
> Please submit your patches to Greg and the USB development list.
> Greg has a directory on kernel.org where the scheduled patches are stored.

Specifically, I use this:
/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb

Look at README inside, it has the base kernel version. Also, use
series file to apply; don't just use shell globbing, or conflicts
will happen.

-- Pete
