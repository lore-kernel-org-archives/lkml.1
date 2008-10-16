Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYJPEL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYJPEL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 00:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYJPELt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 00:11:49 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38205 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYJPELt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 00:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tevZ0Gbg97BZLv5XrninoBRQ5Ww8hO1KBCb2cyMHNpKh0SKS0IXjc1ckMz6ffjj2wI
         JdgaYUNkbrr1AWRRA/BQBG58T2gJuya/3IAmmbS0zmwHdx/W2cGUCJkzYl9Ab0AvyyT0
         dhHAoldDUKw/hlO93AcbisBqTJR9E9K6UxB2Q=
Date: Thu, 16 Oct 2008 00:11:44 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Bader <sbader3@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8042: Add Blue FB5601 to noloop exception table
Message-ID: <20081016041144.GD16860@anvil.corenet.prv>
References: <5201e28f0810140855v77031cf7rbdbcaae981c7124b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201e28f0810140855v77031cf7rbdbcaae981c7124b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 11:55:43AM -0400, Stefan Bader wrote:
> Hi,
> 
> this is another user reported Laptop which works with the noloop option.
> 
> > i have had a laptop for two years now and i have never thought that its touchpad would ever work nor at least be detected.
> > until i come accross this thread. that i8042.noloop=1 option in grub was the magic!
> 

Will apply, thank you Stefan.

-- 
Dmitry
