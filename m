Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041Ab0ATWAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0ATWAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903Ab0ATWA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:00:29 -0500
Received: from fn.samba.org ([216.83.154.106]:40058 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab0ATWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:00:27 -0500
Date: Wed, 20 Jan 2010 14:00:23 -0800
From: Jeremy Allison <jra@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: zhou peng <ailvpeng25@gmail.com>, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: About ACL for IPC Object
Message-ID: <20100120220023.GC4141@jeremy-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com>
 <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com>
 <20100120215048.GB4141@jeremy-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120215048.GB4141@jeremy-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 01:50:48PM -0800, Jeremy Allison wrote:
> On Wed, Jan 20, 2010 at 05:20:00PM +0800, zhou peng wrote:
> > Hi all,
> > 
> > There are ACL in file system, but why there are no ACL implementation
> > in IPC object, eg. shm, message queue, FIFO?
> > Is there any fine grained granting in ipc object just like in file object?
> 
> Not implemented yet, we can add this if you need it
> (but probably will be a 3.6.0 feature).

Never mind, got my lists mixed up and thought this
was a Samba request (sorry :-).
