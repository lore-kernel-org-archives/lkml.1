Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYEMWKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYEMWKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYEMWKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:10:25 -0400
Received: from ns.suse.de ([195.135.220.2]:35586 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbYEMWKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:10:24 -0400
Date: Tue, 13 May 2008 15:06:29 -0700
From: Greg KH <gregkh@suse.de>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 20/37] {nfnetlink, ip, ip6}_queue: fix skb_over_panic
	when enlarging packets
Message-ID: <20080513220627.GA18320@suse.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201218.GU31167@suse.de> <877idxdb04.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877idxdb04.fsf@natisbad.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 01:45:15AM +0200, Arnaud Ebalard wrote:
> Hi,
> 
> Greg KH <gregkh@suse.de> writes:
> 
> > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> Sorry for the noise, but for those who missed one of the latest post on
> the topic on netdev, I should add that the bug is also in 2.6.24.4 (even
> if it's probably too late for that poor guy :-( ).  

Sorry, yes, we are no longer doing 2.6.24-stable releases.

thanks,

greg k-h
