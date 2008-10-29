Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYJ2VNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYJ2VNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYJ2VNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:13:14 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:56926 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYJ2VNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:13:13 -0400
Date: Wed, 29 Oct 2008 14:13:12 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Scott Wood <scottwood@freescale.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] net: add PCINet driver
Message-ID: <20081029211312.GJ12879@ovro.caltech.edu>
Mail-Followup-To: Scott Wood <scottwood@freescale.com>,
	Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20081029202027.GH12879@ovro.caltech.edu> <20081029132506.55b93555@extreme> <20081029205002.GI12879@ovro.caltech.edu> <4908CD96.300@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4908CD96.300@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 29 Oct 2008 14:13:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 03:54:46PM -0500, Scott Wood wrote:
> Ira Snyder wrote:
>> I know about this. I was following the example set forth in
>> drivers/net/fs_enet. 
>
> I recommend against that. :-)

Great, now you tell me :)

I'll go ahead change the typedef to a struct. Hopefully some of the
other inspiration I took wasn't too bad. I'm totally open to suggestions
on improvements for this driver.

Ira
