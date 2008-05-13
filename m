Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbYEMU1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbYEMU1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbYEMUTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:19:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34967 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761077AbYEMUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:19:39 -0400
Date: Tue, 13 May 2008 13:16:02 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix kobject_rename and !CONFIG_SYSFS v2
Message-ID: <20080513201602.GA31578@kroah.com>
References: <m163tocw43.fsf_-_@frodo.ebiederm.org> <20080512220232.GA16914@kroah.com> <m1prrqbseh.fsf@frodo.ebiederm.org> <4829A4BD.3020007@bull.net> <20080513164438.GA31563@kroah.com> <m18wyeay1q.fsf_-_@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wyeay1q.fsf_-_@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:55:45AM -0700, Eric W. Biederman wrote:
> 
> When looking at kobject_rename I found two bugs with
> that exist when sysfs support is disabled in the kernel.

<snip>

Better, but can you address Randy's objections?

thanks,

greg k-h
