Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYFQMlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYFQMlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbYFQMlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:41:13 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2804 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYFQMlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:41:13 -0400
Date: Tue, 17 Jun 2008 14:39:18 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
Message-ID: <20080617123918.GA2397@deprecation.cyrius.com>
References: <20080616150550.GA16086@deprecation.cyrius.com> <48568503.90607@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48568503.90607@codemonkey.ws>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori <anthony@codemonkey.ws> [2008-06-16 10:21]:
>> Any idea if this is a kernel bug, BIOS issue or a bug in VMplayer?
>
> This has been fixed in the latest KVM code base AFAIK.

Can you give some more information?  Which commit fixed the problem?
Was the patch submitted to the 2.6.25-stable tree?
-- 
Martin Michlmayr
http://www.cyrius.com/
