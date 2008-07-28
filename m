Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbYG1Vt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbYG1Vt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbYG1Vtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:49:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:36625 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYG1Vtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VKoQ5vZxKV+bj6gZN0J6Tfy5aPt/SOTCUKS6HVc19oQc7axewJBG/dYS6H3ldCEnAL
         RnMwQOMZkyAf6RLFkcgot5AIPJfLcWzr7mYrKjoSDz9A79/8g2vKOsTrchc2eo5v60NN
         7ItEIqunOEoYf37bnS1slBJbhD9jmdtpqe6CY=
Message-ID: <4d8e3fd30807281449t2b68e84cx674a2a9b91207295@mail.gmail.com>
Date: Mon, 28 Jul 2008 22:19:45 +0030
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Dave Jones" <davej@redhat.com>,
       "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@fenrus.demon.nl>
Subject: Re: [PATCH] x86: Coding style fixes to arch/x86/kernel/cpu/cpufreq/powernow-k6.c
In-Reply-To: <20080728205045.GB11581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080728210816.4989c3f0@paolo-desktop>
	 <20080728205045.GB11581@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Dave Jones <davej@redhat.com> wrote:
>  > Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
>
> I'll queue this up in cpufreq.git


thank you Dave and apologize for not sending you directly the patch.

you might want to look at the other patch i sent a few hours ago, subject was:
Subject: [PATCH] x86: Coding style fixes to
arch/x86/kernel/cpu/cpufreq/elanfreq.c

ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
