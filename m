Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYFYVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYFYVzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYFYVza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:55:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:11148 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYFYVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sxox1W86CQJcGf4dk+5tjCkf/5Tg5Q5RTcvgGr8qkZYRjCubH0qmnbXW7AhOFDk14z
         OXT+jdT71ng+WoksEdcwFWq++PcNJ7qe78QYz3DQgnLcyom0Pk/t+B7AqBpL6lbgmLaz
         lEvQGkJB3bkho76GnDjhAXueUKrQ+S1UARFdM=
Date: Wed, 25 Jun 2008 22:52:24 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: vgoyal@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080625215224.GA14857@hack.netcabo.pt>
References: <1214430592-18043-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214430592-18043-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:49:52PM +0200, Bernhard Walle wrote:
>I would suggest to remove the "experimental" status from Kdump.
>Kdump is now in the kernel since a long time and used by Enterprise
>distributions. I don't think that "experimental" is true any more.
>

Agreed. Thanks.


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
