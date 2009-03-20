Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZCTBmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZCTBmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZCTBmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:42:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33893 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZCTBme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:42:34 -0400
Date: Thu, 19 Mar 2009 19:42:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yu Zhao <yu.zhao@intel.com>, linux-pci@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090320014230.GD14127@parisc-linux.org>
References: <1236756349-18892-1-git-send-email-yu.zhao@intel.com> <1236756349-18892-2-git-send-email-yu.zhao@intel.com> <20090319195312.GC14127@parisc-linux.org> <20090319182016.33a9a1f2@hobbes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319182016.33a9a1f2@hobbes.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 06:20:16PM -0700, Jesse Barnes wrote:
> Ok Yu, I'm ready to apply this set, can you send an updated one with
> the fixes Matthew mentioned?

And please add Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
to each of the patches.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
