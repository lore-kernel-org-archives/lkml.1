Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYHIP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYHIP0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYHIP0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:26:44 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:55897 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYHIP0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:26:43 -0400
Date: Sat, 9 Aug 2008 18:26:33 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Diego Zuccato <diego@otello.alma.unibo.it>
Cc: Alan Stern <stern@rowland.harvard.edu>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [regression?] usb: new errors during device detection
Message-ID: <20080809152632.GA7574@frodo>
Reply-To: me@felipebalbi.com
References: <Pine.LNX.4.44L0.0808061814250.2145-100000@iolanthe.rowland.org> <489D9B46.60001@otello.alma.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489D9B46.60001@otello.alma.unibo.it>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 03:27:34PM +0200, Diego Zuccato wrote:
> Urgh... What happens if it contains a mounted filesystem?
> Seems quite dangerous...

It still enumerating, you'll never have a mounted fs at this point :-)

-- 
balbi
