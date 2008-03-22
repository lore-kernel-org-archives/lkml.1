Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYCVDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYCVDy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYCVDyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:54:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44866 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYCVDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:54:19 -0400
Date: Sat, 22 Mar 2008 03:54:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080322035415.GZ10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk> <20080322034950.GY10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322034950.GY10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 03:49:50AM +0000, Al Viro wrote:
> ->umount_begin() instances, then restore sane prototype for shrink_submounts().

s/shrink_submounts/->umount_begin/ in the line above
