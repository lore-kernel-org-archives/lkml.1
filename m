Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZGGF6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZGGF6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZGGF63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:58:29 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64528 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZGGF62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hxwn4rQJpdGEljnvNfHCi0UR39fsCbRvspDwGx1/wcekvQqgzLUNaJr3xcN6j6h572
         Vb+j/4a7PcjDdcnENjJQOKtORodZjVZ0BzhKnaYRsK9Rd2l58ru6zWStCSZEfpbjsxUd
         E3S/JdbK4JtVcWo2K6HPOpJb2IUNM+ZI1T6Ac=
Date: Tue, 7 Jul 2009 07:57:58 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>, Dave Jones <davej@redhat.com>
Subject: Re: [Bug #13647] fb/mmap lockdep report.
Message-ID: <20090707055758.GA3071@ami.dom.local>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.usG.AApUKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bXZeuxPQAWE.A.usG.AApUKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:00:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13647
> Subject		: fb/mmap lockdep report.
> Submitter	: Dave Jones <davej@redhat.com>
> Date		: 2009-06-21 13:33 (16 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=513adb58685615b0b1d47a3f0d40f5352beff189
> References	: http://lkml.org/lkml/2009/6/21/90
> 		  http://lkml.org/lkml/2009/6/21/122

This lockdep report isn't triggered by 2.6.31-rc2 anymore.

Thanks,
Jarek P.
