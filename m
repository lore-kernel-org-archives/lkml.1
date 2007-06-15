Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXFODF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXFODF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXFODFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:05:12 -0400
Received: from ns.suse.de ([195.135.220.2]:49491 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbXFODFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:05:10 -0400
From: Neil Brown <neilb@suse.de>
To: david@lang.hm
Date: Fri, 15 Jun 2007 13:05:03 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18034.479.256870.600360@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: message from david@lang.hm on Thursday June 14
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday June 14, david@lang.hm wrote:
> what is the limit for the number of devices that can be in a single array?
> 
> I'm trying to build a 45x750G array and want to experiment with the 
> different configurations. I'm trying to start with raid6, but mdadm is 
> complaining about an invalid number of drives
> 
> David Lang

"man mdadm"  search for "limits".  (forgive typos).

NeilBrown
