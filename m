Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYADMo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYADMo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYADMow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:44:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:44896 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYADMov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LCmYY7+tWcHI2d/aBP3jzierNUg15c3EPTGWOtQxZ0oOxVOblf/LI6ClzG+zzUZJs01eOzwvwZkS84uRtddB/UlgTd4f0QK3Rqr9iEtAyvKJkWnTaVbJDeKcjcsNMq3E4mghEtymwyts82uOFug5TRqnn6r36JguVCiPQiKZvCI=
Message-ID: <75b66ecd0801040444y4d698d7fh9caf52955b2b6aad@mail.gmail.com>
Date: Fri, 4 Jan 2008 07:44:51 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Improve hackbench
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080104081043.GA23046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199426786.3298.64.camel@ymzhang> <20080104081043.GA23046@elte.hu>
X-Google-Sender-Auth: 3e640b2e4f7146fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 3:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>   http://redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
>

Why not lose the #ifdef and just use PTHREAD_STACK_MIN?

Lee
