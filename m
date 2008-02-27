Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbYB0A60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbYB0A60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933128AbYB0A6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:58:05 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:41066 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbYB0A6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:58:02 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATH] Add iSCSI iBFT support (v0.4.8)
Date: Tue, 26 Feb 2008 19:55:14 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       michaelc@cs.wisc.edu,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       dwm@enoyolf.org, darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
References: <20080212221311.GA20304@andromeda.dapyr.net>
In-Reply-To: <20080212221311.GA20304@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261955.19017.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 17:13:11 Konrad Rzeszutek wrote:
> This patch (v0.4.8) adds /sysfs/firmware/ibft/[initiator|targetX|ethernetX]
> directories along with text properties which export the the iSCSI
> Boot Firmware Table (iBFT) structure.

James,

This patch has the fixes you mentioned in the earlier code review (0.4.7). 
Could you take a look at this patch and see if it meets your expectations, 
please?

Thanks.
