Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbXJJUcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbXJJUcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXJJUci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:32:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38947 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755659AbXJJUch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:32:37 -0400
Message-ID: <392048357.06732@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 11 Oct 2007 04:32:32 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>, Avi Kivity <avi@argo.co.il>,
       lkml <linux-kernel@vger.kernel.org>, david-g@263.net
Subject: Re: x86_64 : kernel initial decompression hangs on vmware
Message-ID: <20071010203232.GA6088@mail.ustc.edu.cn>
References: <392001863.28140@ustc.edu.cn> <200710101518.42830.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710101518.42830.ak@suse.de>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 03:18:42PM +0200, Andi Kleen wrote:
> On Wednesday 10 October 2007 09:37:39 Fengguang Wu wrote:
> 
> > One of my friends' vmware "hangs" 
> 
> It should just be a little slow. VMware seems to do something fishy
> here -- KVM or Xen using VT don't have this issue.

Yeah, it's a false hang ;-)

> > on booting Linux 2.6.23, and then get 
> > it to work by applying your patch at http://lkml.org/lkml/2007/8/4/72.
> 
> The patch is already in 2.6.23; it was just missing in .22. Perhaps
> your friend confused those two.

Ah indeed. Sorry for the noise.

Fengguang

