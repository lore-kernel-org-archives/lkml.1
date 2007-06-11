Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbXFKHfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbXFKHfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXFKHfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:35:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbXFKHfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:35:39 -0400
Date: Mon, 11 Jun 2007 00:35:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: Mario Guenterberg <mg@havelsoft.com>, linux-wireless@vger.kernel.org
Subject: Re: some iwlwifi problems
Message-Id: <20070611003529.2a0c1136.akpm@linux-foundation.org>
In-Reply-To: <20070607082609.GA4603@/bin/dnsdomainname>
References: <20070607082609.GA4603@/bin/dnsdomainname>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 10:26:09 +0200 Mario Guenterberg <mg@havelsoft.com> wrote:

> Hi...
> 
> I have compiled the 2.6.22-rc4 kernel with the mm1 patchset.
> It works fine for my z16m lenovo laptop. The only mistake I have is
> the iwlwifi driver for the Intel Corporation PRO/Wireless 3945ABG
> network controller. The bitrate settings are sometimes very different.
> Sometimes it says 6 Mb/s, sometimes 11 Mb/s or 54 Mb/s and maybe 
> sometimes 5.5 Mb/s.
> 
> The other thing is the message in log:
> wlan0: duplicate address detected!
> I have no machine with the same address in my network and no other
> accesspoint in the range of my wlan.
> 
> With the 2.6.22.3 kernel and the iwp3945 driver the bitrate settings 
> only 54 Mb/s and the message never found in logs.
> 

(cc linux-wireless)
