Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbYB2BF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbYB2BF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbYB2Au5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:50:57 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:54621 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbYB2Auy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NExK2o8wTK9HPd6oiUBY7avpp9yFym9/AjrIzBEvB4N1g2GgFWjobTpbNIrGR5KJbdNeAyt/kszij4IqTOrOT368rHXUDs6kYC1sZHvMtM0VM9lQPhQXMpLTsmUiSCwekVFEgjaHWUINzrM10iVV6kfGU7EsV5vVKb1RVbLWO3U=
Subject: Re: [PATCH 11/12] Generic semaphore implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20080229003954.GA525@parisc-linux.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx>
	 <1204180441-8540-4-git-send-email-matthew@wil.cx>
	 <1204180441-8540-5-git-send-email-matthew@wil.cx>
	 <1204180441-8540-6-git-send-email-matthew@wil.cx>
	 <1204180441-8540-7-git-send-email-matthew@wil.cx>
	 <1204180441-8540-8-git-send-email-matthew@wil.cx>
	 <1204180441-8540-9-git-send-email-matthew@wil.cx>
	 <1204180441-8540-10-git-send-email-matthew@wil.cx>
	 <1204180441-8540-11-git-send-email-matthew@wil.cx>
	 <20080228071822.GA13571@elte.hu>  <20080229003954.GA525@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:50:45 -0800
Message-Id: <1204246245.20280.109.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-28 at 17:39 -0700, Matthew Wilcox wrote:
> On Thu, Feb 28, 2008 at 08:18:23AM +0100, Ingo Molnar wrote:
> > very nice work!
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> Thanks!
> 
> Stephen, I've put the semaphore patches into a git tree; can you add it
> to linux-next?
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore
> 

The gitweb links aren't so useful for people to grab your tree, the
format usually preferred is <url> <branchname>

ie:
git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore

Cheers,

Harvey

