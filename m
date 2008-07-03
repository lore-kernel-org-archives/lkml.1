Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYGCARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYGCARg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYGCAR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:17:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:38104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYGCAR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:17:28 -0400
Date: Wed, 2 Jul 2008 17:15:49 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <htejun@gmail.com>, Benjamin Thery <benjamin.thery@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
Message-ID: <20080703001549.GA18880@suse.de>
References: <486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org> <4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org> <486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org> <486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org> <486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14p78s02q.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:49:33AM -0700, Eric W. Biederman wrote:
> Assuming Greg will accept it when he sees reasonable patches.

I always accept "reasonable patches" :)

thanks,

greg k-h
