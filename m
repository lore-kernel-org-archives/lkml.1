Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXCFTJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXCFTJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbXCFTJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:09:07 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60847 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778AbXCFTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:09:05 -0500
Date: Tue, 6 Mar 2007 11:07:33 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, ak@muc.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, rusty@rustcorp.com.au,
       ian.pratt@xensource.com, Christian.Limpach@cl.cam.ac.uk,
       netdev@vger.kernel.org, jeff@garzik.org
Subject: Re: [RFC] ARP notify option
Message-ID: <20070306190733.GY10574@sequoia.sous-sol.org>
References: <20070301164214.4a40bc59@freekitty> <45E7764A.7000100@goop.org> <20070301173030.754514ec@freekitty> <20070305.203536.92584097.davem@davemloft.net> <20070306105132.52c77491@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306105132.52c77491@freekitty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> This adds another inet device option to enable gratuitous ARP
> when device is brought up or address change. This is handy for
> clusters or virtualization.

This looks good.  I'll test with Xen.  What about the source
addr selection?

thanks,
-chris
