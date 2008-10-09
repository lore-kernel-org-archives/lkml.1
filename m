Return-Path: <linux-kernel-owner+w=401wt.eu-S1760354AbYJIS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbYJIS6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYJIS6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:58:15 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:60896 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbYJIS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:58:14 -0400
Date: Thu, 9 Oct 2008 20:58:05 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alex Howells <alex@bytemark.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: r8169 counters, Intel Atom 230 (D945GCLF)
Message-ID: <20081009185805.GA19721@electric-eye.fr.zoreil.com>
References: <48EE1867.1070003@bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EE1867.1070003@bytemark.co.uk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Howells <alex@bytemark.co.uk> :
[...]
> eth0      Link encap:Ethernet  HWaddr 00:1C:C0:5F:DC:02
>           inet addr:89.16.177.251  Bcast:89.16.177.255  Mask:255.255.255.0
>           inet6 addr: fe80::21c:c0ff:fe5f:dc02/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:25218 errors:0 dropped:2758040992 overruns:0 frame:0
                                              ^^^^^^^^^^
[...]
> Any ideas?

It is fixed by patch #0009 at:

http://userweb.kernel.org/~romieu/r8169/2.6.27-rc9/20081007/

-- 
Ueimor
