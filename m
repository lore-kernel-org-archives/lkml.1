Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXHXMac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXHXMac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbXHXMaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:30:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2298 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbXHXMaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:30:22 -0400
Date: Fri, 24 Aug 2007 14:14:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.5 forcedeth timeout hang
Message-ID: <20070824121459.GB28737@1wt.eu>
References: <46CE1CC7.6000507@exegy.com> <20070824050617.GS6002@1wt.eu> <46CEC083.2010708@exegy.com> <20070824115108.GA28737@1wt.eu> <46CECCAF.8050907@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CECCAF.8050907@exegy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 07:18:55AM -0500, Mr. Berkley Shands wrote:
> No joy.
> 
> I did a ping during the "make -j4"... it starts dropping packets, and 
> gets to a 2-in-a-row, then hangs.
> This time there was no error output in /var/log/messages.
> 
> Usually there is something..

Ok, but please keep the list CC'ed. It's the second time I add it myself,
if you remove the people who can help, it will be hard to get a fix.

Willy

