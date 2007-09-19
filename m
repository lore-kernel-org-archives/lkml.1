Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXISRKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXISRKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXISRKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:10:36 -0400
Received: from baikonur.stro.at ([213.239.196.228]:4596 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbXISRKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:10:35 -0400
Date: Wed, 19 Sep 2007 19:10:33 +0200
From: maximilian attems <max@stro.at>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, mchan@broadcom.com,
       vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
Message-ID: <20070919171033.GH6618@stro.at>
References: <46F01BDE.6020902@zytor.com> <20070918.122034.83625273.davem@davemloft.net> <46F02688.8030507@zytor.com> <20070918.130810.78161599.davem@davemloft.net> <20070918203530.GC27836@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918203530.GC27836@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Sam Ravnborg wrote:

> Anyway - if we again consider klibc I will do my best to make the
> build stuff as smooth as possible.
> 
> 	Sam

<nitpicking mode on>
currently klibc has tendency to rebuild a bit too much if you
touch some part of it, seen in usr/utils
for the main klibc i agree that it makes sense

-- 
maks
