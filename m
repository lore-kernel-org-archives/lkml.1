Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZAEXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZAEXbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZAEXbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:31:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:41090 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZAEXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CRC3tj5omKPvmBFn2M69KGqANvUs8LQvlopokMxUy0P1DEZVwSgO7OmrGo9omRJ97l
         7Oj/hrhmUEAV0wy9dt34oonmSYseVIQyLE6Ops+SP62KpkWRd8uYH5trkeKlYdK/yCDG
         KFtXKHLCYqT6Qlg1h6PtM86JfxCBFxolWRTeI=
Date: Tue, 6 Jan 2009 02:36:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: ebiederm@xmission.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: Re: [PATCH 1/6] proc: implement support for automounts in task
	directories
Message-ID: <20090105233617.GA4141@x200.localdomain>
References: <20090105233241.GA3924@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105233241.GA3924@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 02:32:41AM +0300, Alexey Dobriyan wrote:
> This is current version of /proc/net as separate file system patchset,
> rebased, etc. I'll put it into -next again when merge window closes.

Currently everything is at

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-wip
