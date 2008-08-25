Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYHYRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYHYRNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYHYRNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:13:11 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:13035 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYHYRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L5YF+awZPG9Z4PtszdNW2t11fynllNFIa4COBmFlFW7hPGNVIdR49Ic0EPSrAMK8mK
         ODU9nYs2FK1+WcpFkc/kAQGLGV7mYklYIDrYd79ubsrrXtptIc29fhxcqSbOCA3gEBBr
         2+UXwp999fyemp1kuPx5kpG2s90bmX65+N9P4=
Message-ID: <86802c440808251013u20533707w692b5ba94e32e9c9@mail.gmail.com>
Date: Mon, 25 Aug 2008 10:13:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Vivek Goyal" <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080825103948.6ba5757c@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080825103948.6ba5757c@halley.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 1:39 AM, Bernhard Walle <bwalle@suse.de> wrote:
> * Yinghai Lu [2008-08-24 15:44]:
>>
>> may need user to have new kexec tools that could create e820 table
>> from /sys/firmware/memmap instead of /proc/iomem for second kernel
>
> 2.0.0 has that implemented.
>
Yes

can you guys make kexec-tools 2.0.0 can be complied to static as one option?

YH
