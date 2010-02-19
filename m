Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0BSRiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:38:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33094 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0BSRiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fI0wK7E587UXURIDxhk7+6fqx0spFOk1PtnhZ3X4ngL6KjvOFytnPhHAtgImc/csqt
         2IKHP+pVUW0jQR3uaI6jhnHBRFDMCgXQKDahBQYgx5KqzEiVVBmPb5BTZoMxz+WBYyP0
         xq/vKdFqhCN83LkbB6YjonQT81tq1DSVKYOCY=
Date: Fri, 19 Feb 2010 18:38:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/2] hw-breakpoints: Accept breakpoints on NULL address
Message-ID: <20100219173758.GC4921@nowhere>
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-2-git-send-regression-fweisbec@gmail.com> <20100218211659.9C06E4F7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218211659.9C06E4F7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 01:16:59PM -0800, Roland McGrath wrote:
> Setting a watchpoint on address 0 seems like an entirely reasonable thing
> to do.  This change looks right to me.
> 
> Thanks,
> Roland

I'm adding you ack then. Thanks.

