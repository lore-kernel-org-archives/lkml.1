Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXELTMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXELTMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXELTMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:12:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40455 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbXELTMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:12:42 -0400
Message-ID: <464611A6.3040301@zytor.com>
Date: Sat, 12 May 2007 12:12:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mark Glines <mark@glines.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
References: <20070511170135.7c38615f@chirp>	<4645227F.3030905@zytor.com> <20070512121009.18c8b68a@chirp>
In-Reply-To: <20070512121009.18c8b68a@chirp>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Glines wrote:
> 
> Well, in that case, is there anything wrong with just using the
> range IANA recommends, in all cases?
> 

I think the IANA range is considered too small in most cases; I suspect
there is also a feeling that "there be dragons" near the very top.

	-hpa
