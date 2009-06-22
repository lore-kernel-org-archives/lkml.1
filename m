Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZFVPag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZFVPag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZFVPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:30:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbZFVPa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:30:28 -0400
Date: Mon, 22 Jun 2009 08:29:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-Id: <20090622082941.c5c8b3f3.akpm@linux-foundation.org>
In-Reply-To: <20090622124951.GB30553@elte.hu>
References: <20090506225115.GM6771@linux.vnet.ibm.com>
	<20090506112459.5edd0902.akpm@linux-foundation.org>
	<20090502163423.GA1633@linux.vnet.ibm.com>
	<12234.1241558327@redhat.com>
	<20090506120909.GR25203@elte.hu>
	<11979.1241648574@redhat.com>
	<26931.1245670998@redhat.com>
	<20090622124951.GB30553@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 14:49:51 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Howells <dhowells@redhat.com> wrote:
> 
> > Hi Paul,
> > 
> > Are you going to push your RCU patch for this merge window?
> 
> Andrew needs to be convinced for that to happen.
> 

whome?  I rarely have firm opinions on anything.  iirc the question
here was "is it worth adding another RCU implementation to save 900
bytes"?

I find it pretty hard to see how to come up with "yes" for that one but
it's hardly a huge issue.  If you guys feel otherwise then go wild.

