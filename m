Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZAMB0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZAMB0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZAMBZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:25:56 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:26813 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbZAMBZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RuccPxjYP3zcApH9YwE8DLT/DDA8VbzzpJ4u9XiG6Sgd37EbPkYYMt7zla9NJOho7+
         8f416RqFZMY4OiyDAG+3T78vxxx8cApJSpXXneh47NjOY1ER/asLSpTuqFd4Nizy3/Rl
         Uch8g2zV1GeURiTWBIo4EMmVySfVy8DusAhhI=
Message-ID: <8bd0f97a0901121725y21b1b914wed5d0cf5caa0863b@mail.gmail.com>
Date: Mon, 12 Jan 2009 20:25:55 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc cpumask_var_t's.
Cc: "Ingo Molnar" <mingo@redhat.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jack Steiner" <steiner@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <496BEC86.1070701@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
	 <8bd0f97a0901121407ude0b816i2ebd36c3d24036e9@mail.gmail.com>
	 <496BEC86.1070701@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 20:21, Mike Travis wrote:
> Mike Frysinger wrote:
>> On Mon, Jan 12, 2009 at 17:05, Mike Travis wrote:
>>> Cc: Bryan Wu <cooloney@kernel.org>
>>
>> Blackfin CC should be more uclinux-dist-devel@blackfin.uclinux.org
>
> I saw that but it's flagged:
>
> L:      uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
>
> I assumed that means the list does not want unsolicited mail?

no, it doesnt mean that.  it's moderated due to spammers and the
original merge required the marking regardless of purpose.  ive
updated the local MAINTAINERS file to remove that since all moderation
of non-subscribers is done transparently (no annoying notifications /
etc...).
-mike
