Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZCXWsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZCXWsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZCXWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:48:26 -0400
Received: from mail.vyatta.com ([76.74.103.46]:52953 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZCXWsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:48:25 -0400
Date: Tue, 24 Mar 2009 15:48:18 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 v2.6.29
Message-ID: <20090324154818.25833859@nehalam>
In-Reply-To: <20090324.153822.75287783.davem@davemloft.net>
References: <20090324153427.3ff0dfdb@nehalam>
	<20090324.153822.75287783.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 15:38:22 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Tue, 24 Mar 2009 15:34:27 -0700
> 
> > Trying to stay on top of things (for a change).
> > 
> > New version of iproute2 utilities that includes bug fixes and
> > support for all the new features in kernel 2.6.29.
> > 
> >   http://devresources.linux-foundation.org/dev/iproute2/download/iproute2-2.6.29.tar.bz2
> 

Thanks including <linux/ip.h> fixed that.

  http://devresources.linux-foundation.org/dev/iproute2/download/iproute2-2.6.29-1.tar.bz2
