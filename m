Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbZHVU0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbZHVU0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbZHVU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:26:43 -0400
Received: from khc.piap.pl ([195.187.100.11]:47467 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZHVU0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:26:42 -0400
To: Walt Holman <walt@holmansrus.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
References: <987943678.21250869504786.JavaMail.root@mail.holmansrus.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 22 Aug 2009 22:26:41 +0200
In-Reply-To: <987943678.21250869504786.JavaMail.root@mail.holmansrus.com> (Walt Holman's message of "Fri\, 21 Aug 2009 10\:45\:04 -0500 \(CDT\)")
Message-ID: <m3vdkfh9xa.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Walt Holman <walt@holmansrus.com> writes:

> Just got a chance to test this for confirmation.  When limiting the
> RAM to 2GB, the patched driver appears to work OK.

Thanks for confirming this.
-- 
Krzysztof Halasa
