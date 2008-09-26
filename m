Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbYIZWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbYIZWU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYIZWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:20:12 -0400
Received: from [198.145.64.141] ([198.145.64.141]:44957 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751966AbYIZWUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:20:11 -0400
Date: Fri, 26 Sep 2008 15:16:26 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 2/11] fsnotify: pass a file instead of an
	inode to open modify and read
Message-ID: <20080926221626.GA10141@kroah.com>
References: <1222463900.2872.211.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222463900.2872.211.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 05:18:20PM -0400, Eric Paris wrote:
> pass a file instead of an inode to open, modify, close

Why?  It would be helpful to describe the need for this change in this
log comment.

thanks,

greg k-h
