Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXIRUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXIRUlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXIRUlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:41:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXIRUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:41:10 -0400
Message-ID: <46F037D7.5020202@zytor.com>
Date: Tue, 18 Sep 2007 13:40:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Miller <davem@davemloft.net>, mchan@broadcom.com,
       vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
References: <46F01BDE.6020902@zytor.com> <20070918.122034.83625273.davem@davemloft.net> <46F02688.8030507@zytor.com> <20070918.130810.78161599.davem@davemloft.net> <20070918203530.GC27836@uranus.ravnborg.org>
In-Reply-To: <20070918203530.GC27836@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> Except there seems to be great resistance to include userland code in the
> kernel as demonstrated at last KS. Or this is maybe just a single vocal
> person and the topic were brought up late?
> 
> Anyway - if we again consider klibc I will do my best to make the
> build stuff as smooth as possible.
> 

At least as of the last merged tree it was very smooth indeed, thanks to
your help.

	-hpa
