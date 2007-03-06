Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXCFTEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXCFTEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030396AbXCFTEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:04:33 -0500
Received: from gw.goop.org ([64.81.55.164]:54642 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030351AbXCFTEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:04:32 -0500
Message-ID: <45EDBB3D.604@goop.org>
Date: Tue, 06 Mar 2007 11:04:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org
Subject: Re: [RFC] ARP notify option
References: <20070301164214.4a40bc59@freekitty>	<45E7764A.7000100@goop.org>	<20070301173030.754514ec@freekitty>	<20070305.203536.92584097.davem@davemloft.net> <20070306105132.52c77491@freekitty>
In-Reply-To: <20070306105132.52c77491@freekitty>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> This adds another inet device option to enable gratuitous ARP
> when device is brought up or address change. This is handy for
> clusters or virtualization.
>   

Thanks Stephen.  Haven't tested this yet, but it definitely cleans up a
warty corner of netfront.

    J
