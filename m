Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYIZWUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYIZWUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:20:12 -0400
Received: from [198.145.64.141] ([198.145.64.141]:44961 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752061AbYIZWUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:20:11 -0400
Date: Fri, 26 Sep 2008 15:17:16 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 3/11] fanotify: fscking all notify, system
	wide file access notification
Message-ID: <20080926221716.GB10141@kroah.com>
References: <1222463904.2872.212.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222463904.2872.212.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 05:18:24PM -0400, Eric Paris wrote:
> fanotify: fscking all notify, system wide file access notification

Userspace api changes/additions need to also cc: the
linux-api@vger.kernel.org list now.

thanks,

greg k-h
