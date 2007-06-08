Return-Path: <linux-kernel-owner+w=401wt.eu-S937911AbXFHJMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937911AbXFHJMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 05:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763954AbXFHJMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 05:12:41 -0400
Received: from twin.jikos.cz ([213.151.79.26]:47230 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976AbXFHJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 05:12:40 -0400
Date: Fri, 8 Jun 2007 11:12:29 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Robert de Rooy <robert.de.rooy@gmail.com>
cc: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: ThinkPad T41 - Strange USB 2.0 behaviour
In-Reply-To: <46687BD3.1020603@gmail.com>
Message-ID: <Pine.LNX.4.64.0706081110330.23280@twin.jikos.cz>
References: <46686937.9050306@gmail.com> <20070607205015.GD6528@ca-server1.us.oracle.com>
 <46687BD3.1020603@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Robert de Rooy wrote:

> Yes I figured it was a hardware problem, but that was not really the 
> point I was trying to raise ;). I would like, if possible for Linux to 
> automatically fallback to USB 1.1 like Windows does (preferably with a 
> suitable warning).

What do you propose as a trigger for the kernel to fallback?

You can work it around manually, just don't use ehci-hcd, can't you?

-- 
Jiri Kosina
