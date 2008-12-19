Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYLSLwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYLSLwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYLSLvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:51:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:60588 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYLSLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Hl8W3f4b+K/+Rq6jsGhZdXFvSHADfoHttURv3ojOunw5kKem6303Q6fo2dkrc02nPv
         VuLM11ht2t2AevCsue8EM2t5Fa4p6eH+rFE/hHwpqd4MoQ2eI8x4578Smtn4gsAwB2FS
         Zga1LXBHmsmP+xOTrvmPZfexR7HmnXpR2oiGM=
Message-ID: <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com>
Date: Fri, 19 Dec 2008 03:51:53 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333 smp_call_function_mask
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, mel@csn.ul.ie
In-Reply-To: <20081219105441.GA19750@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
	 <20081219105441.GA19750@linux.vnet.ibm.com>
X-Google-Sender-Auth: 1be22699d020332f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 2:54 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> Hi,
>
>        next-200816 kernel panics, while boot up on x86_64 machine.
>
> Initializing CPU#0
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> IP: [<ffffffff80700449>] init_ISA_irqs+0x18/0x53

.config and good boot log?

YH
