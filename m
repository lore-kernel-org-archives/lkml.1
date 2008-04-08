Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYDHAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYDHAdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYDHAdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:33:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYDHAdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:33:10 -0400
Date: Mon, 7 Apr 2008 20:33:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: fully bisectable real time series
In-Reply-To: <1207611243.21308.167.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0804072027080.7121@gandalf.stny.rr.com>
References: <1207611243.21308.167.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 7 Apr 2008, Daniel Walker wrote:

>
> I've re-worked the -rt series, and some of the core patches to make it
> all bisectable. I've done bisect updates in the past which really only
> scratched the surface.
>

Daniel,

Thanks, for doing this. I'll try to look at it when I get a chance. If you
can make a bisectable series that still gives a byte for byte identical
kernel with a make allyesconfig, I'll incorporate it.

-- Steve

