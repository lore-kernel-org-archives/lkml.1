Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZBZDja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZBZDja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZBZDjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:39:21 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59438 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBZDjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:39:20 -0500
Date: Wed, 25 Feb 2009 21:39:18 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] keys: make procfiles per-user-namespace
Message-ID: <20090226033917.GA3826@us.ibm.com>
References: <20090225210336.GA20086@us.ibm.com> <20090223204041.GA31626@us.ibm.com> <20090109225313.GB15599@us.ibm.com> <20090109225208.GA15252@us.ibm.com> <5296.1234522990@redhat.com> <16728.1235565664@redhat.com> <7386.1235606002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7386.1235606002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > So you want users to be able to mmap the file and lseek to a particular
> > spot?
> 
> mmap?  *blink*

/me pretends he didn't say that

> > Meanwhile, do you have any objections to these 4 patches?  :)
> 
> Not really.  You can add my Acked-by.

Thanks.

> It's just that mapping fpos to keyid
> might simplify the code.

Ok i think i see what you mean.  I'll give it a shot.

thanks,
-serge
