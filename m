Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXCAU5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXCAU5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030255AbXCAU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:57:35 -0500
Received: from mail.samba.org ([66.70.73.150]:53752 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030243AbXCAU5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:57:33 -0500
X-Greylist: delayed 1566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 15:57:33 EST
Date: Thu, 1 Mar 2007 12:31:18 -0800
From: Jeremy Allison <jra@samba.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070301203118.GL15090@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <45E73637.1000508@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E73637.1000508@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 03:23:19PM -0500, Jeff Garzik wrote:
> I certainly agree that we want something like this.
> 
> posix_fallocate() is the glibc interface we want to be compatible with 
> (which your definition is, AFAICS).

This would be great for Samba. Windows clients do this a lot....

Jeremy.
