Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbXKHUUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbXKHUUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760864AbXKHUUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:20:10 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:47736 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758198AbXKHUUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:20:08 -0500
Date: Thu, 8 Nov 2007 12:20:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Plans for Onezonelist patch series ???
In-Reply-To: <20071108200607.GD23882@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711081218250.10074@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <1194535612.6214.9.camel@localhost>
 <1194537674.5295.8.camel@localhost> <Pine.LNX.4.64.0711081033570.7871@schroedinger.engr.sgi.com>
 <20071108184009.GC23882@skynet.ie> <Pine.LNX.4.64.0711081043420.7871@schroedinger.engr.sgi.com>
 <20071108200607.GD23882@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Mel Gorman wrote:

> I've rebased the patches to mm-broken-out-2007-11-06-02-32. However, the
> vanilla -mm and the one with onezonelist applied are locking up in the
> same manner. I'm way too behind at the moment to guess if it is a new bug
> or reported already. At best, I can say the patches are not making things
> any worse :) I'll go through the archives in the morning and do a bit more
> testing to see what happens.

I usually base my patches on Linus' tree as long as there is no tree 
available from Andrew. But that means that may have to 
approximate what is in there by adding this and that.
