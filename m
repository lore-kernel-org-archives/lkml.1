Return-Path: <linux-kernel-owner+w=401wt.eu-S1764567AbXHXRr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764567AbXHXRr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbXHXRrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:47:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029AbXHXRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:47:19 -0400
Date: Fri, 24 Aug 2007 10:46:01 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>, Shish <shish@shishnet.org>,
       Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>
Subject: Re: [3/4] 2.6.23-rc3: known regressions v3
Message-ID: <20070824104601.04a6b529@localhost>
In-Reply-To: <46CF1796.1020004@googlemail.com>
References: <46CF0DEF.5040107@googlemail.com>
	<46CF1796.1020004@googlemail.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O
> Subject         : New wake ups from sky2
> References      : http://lkml.org/lkml/2007/7/20/386
> Last known good : ?
> Submitter       : Thomas Meyer <thomas@m3y3r.de>
> Caused-By       : Stephen Hemminger <shemminger@osdl.org>
>                   commit eb35cf60e462491249166182e3e755d3d5d91a28
> Handled-By      : Stephen Hemminger <shemminger@osdl.org>
> Status          : unknown
> 
>

Fix posted to netdev (sky2 1.17 series), but Jeff hasn't 
applied it.
