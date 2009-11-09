Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZKIIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZKIIcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZKIIcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:32:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:62348 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZKIIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lAIlDyQbN9QRwpoavb5YAaeZp7BhbkefvDIK/3DhK78ADqO1Ci2MN7KZE1Jo0M/dCu
         DsimTyZ9fMRjzuPVptOMMu1fzHY+lsQSfGMJ2px93NpTa5arPVTYSrhuN7PLRYSDw7Ql
         g5/PZ/F6XAg9FNtFQDzQlJ/9lGy45Sk1F9lZE=
Message-ID: <4AF7D396.4080304@gmail.com>
Date: Mon, 09 Nov 2009 09:32:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF3F3CF.5080503@gmail.com> <20091108103629.GA11372@elte.hu> <20091109001003.GA4129@localhost.localdomain>
In-Reply-To: <20091109001003.GA4129@localhost.localdomain>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 01:10 AM, Neil Horman wrote:
> That seems like a reasonable approach to me.  Jiri, would you like to do that or
> shall I?  I'm happy to but it will take me a few days (I've got a bug I need to
> focus on first).

Yup, I'll do that. v7 is the newest version you sent, right?

Thanks.
