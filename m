Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYBDTff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYBDTff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbYBDTf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:35:27 -0500
Received: from mail.suse.de ([195.135.220.2]:58093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbYBDTf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:35:27 -0500
Date: Mon, 4 Feb 2008 20:35:25 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: [mm] Crashkernel memory reservation fails with 2.6.24-rc8-mm1
Message-ID: <20080204193524.GA11104@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@redhat.com>,
	"Sachin P. Sant" <sachinp@in.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kexec@lists.infradead.org
References: <47A7391F.2020408@in.ibm.com> <20080204183810.GE16021@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204183810.GE16021@redhat.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2008-02-04 19:38]:
> 
> Bernahard, any idea who is the competitor here?

Hm ..., can you boot the kernel without crashkernel= and provide the
/proc/iomem?


        Bernhard
