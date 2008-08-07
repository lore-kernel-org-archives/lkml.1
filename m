Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYHGUng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYHGUng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYHGUn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:43:28 -0400
Received: from iabervon.org ([66.92.72.58]:37342 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbYHGUn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:43:27 -0400
Date: Thu, 7 Aug 2008 16:43:26 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: jmerkey@wolfmountaingroup.com
cc: Chris Friesen <cfriesen@nortel.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
In-Reply-To: <2364.69.2.248.210.1217954354.squirrel@webmail.wolfmountaingroup.com>
Message-ID: <alpine.LNX.1.00.0808071626500.19665@iabervon.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>    <Pine.LNX.4.64.0808051140150.6309@anakin>    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>    <200808060133.10457.nickpiggin@yahoo.com.au>   
 <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>    <48987A24.3060000@nortel.com> <2364.69.2.248.210.1217954354.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008, jmerkey@wolfmountaingroup.com wrote:

> Read it already.  Quite a few large companies are using it at present and
> have been since 2000, BTW.

The criterion for kernel inclusion isn't really whether it works, however. 
It's whether other people would be able to understand it well enough to 
support it if you disappear (or if somebody else has changes that require 
changes to it). If it works well but isn't nice code, nobody really 
benefits from having it in the kernel distribution rather than external 
(like it's been for the past 8 years). If it is nice code (somewhat 
regardless of whether it happens to work right now), people can work on it 
and keep it in sync with the kernel as they change things.

	-Daniel
*This .sig left intentionally blank*
