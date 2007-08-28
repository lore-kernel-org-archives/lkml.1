Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXH1Qpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXH1Qpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXH1QpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:45:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXH1QpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:45:11 -0400
Message-ID: <46D45111.2040600@zytor.com>
Date: Tue, 28 Aug 2007 09:45:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   given that "ether=" has been officially obsolete since 2.6.18
> (replaced by "netdev="), is there any reason to keep it around?  or
> can it be blasted?

That sounds like way too short of a timeline for breaking people's
working boot setup.  For a lot of people, 2.6.18->current is going to be
a single step.

	-hpa

