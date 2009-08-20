Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbZHTJWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbZHTJWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 05:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZHTJWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 05:22:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:58270 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZHTJWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 05:22:36 -0400
To: David Miller <davem@davemloft.net>
Cc: walt@holmansrus.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
References: <2087985663.21250727676944.JavaMail.root@mail.holmansrus.com>
	<20090819.211736.222582824.davem@davemloft.net>
	<m3my5ueu2a.fsf@intrepid.localdomain>
	<20090820.021330.151477484.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 20 Aug 2009 11:22:35 +0200
In-Reply-To: <20090820.021330.151477484.davem@davemloft.net> (David Miller's message of "Thu\, 20 Aug 2009 02\:13\:30 -0700 \(PDT\)")
Message-ID: <m3iqgiet5w.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> skb->data is where e100 puts it's descriptors. :-)
>
> But you know that.

Right. I will try to change that soon.
-- 
Krzysztof Halasa
