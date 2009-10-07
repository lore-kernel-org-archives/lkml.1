Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbZJGSLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbZJGSLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbZJGSLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:11:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:45986 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZJGSLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:11:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: BUG with iptables 1.4.4 IMQ and ipset patch
Date: Wed, 7 Oct 2009 11:10:03 -0700
Organization: Linux Foundation
Message-ID: <20091007111003.565f4296@nehalam>
References: <4ACCC25A.200@i-neo.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-117-243-208.ptldor.fios.verizon.net
In-Reply-To: <4ACCC25A.200@i-neo.ro>
X-Newsreader: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 19:31:22 +0300
Epure Daniel <daniel.epure@i-neo.ro> wrote:

> Hello,
> 
> I installed iptables ver. 1.4.4 with an IMQ and ipset patch on a server 
> with linux kernel vers 2.6.29.6. The modified ebuild that apply the 
> patch is attached. Also the kernel config is attached.I got the 
> following error.
> Version of ipset is 2.4.7 - net-firewall/ipset-2.4.7
> Distro is gentoo running on a server dual Intel(R) Xeon(TM) CPU 2.80GHz
> 

Send to netfilter mailing list netfilter@vger.kernel.org
BUT you are using two out of tree patches, so you are better off
mailing the IMQ and ipset maintainers.

-- 


