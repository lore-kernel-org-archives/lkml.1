Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZLVTF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZLVTF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZLVTF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:05:58 -0500
Received: from kroah.org ([198.145.64.141]:48109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZLVTF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:05:57 -0500
Date: Tue, 22 Dec 2009 11:03:45 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: Re: [PATCH] [8/11] SYSCTL: Convert hotplug helper string to
 proc_rcu_string()
Message-ID: <20091222190345.GA26392@kroah.com>
References: <20091221220.243954235@firstfloor.org>
 <20091221012029.AEE3CB158A@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221012029.AEE3CB158A@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 02:20:29AM +0100, Andi Kleen wrote:
> 
> This avoids races with lockless sysctl.
> 
> I also moved the code into a separate function because the original
> was very long.
> 
> Cc: greg@kroah.com
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

