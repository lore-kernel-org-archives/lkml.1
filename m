Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZE3AP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZE3AP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 20:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZE3APU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 20:15:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:10522 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZE3APS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 20:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XS00xfVbr143rYLI/M9UDi/F7DAPPckezICsGA6+XSH1eIHNDEOVE1/8UGVP2Qfo92
         +WZwMfvBX5PWVq314eCGlU0tf046TY4vSP/REamxhlctz/ZC7HkkfYLCQ/uazpR6GwDz
         iOnC3klqMeJ0hXN5tZ2iHSTvJUlg5tHvZLh88=
MIME-Version: 1.0
In-Reply-To: <tip-efb3d17240d80e27508d238809168120fe4b93a4@git.kernel.org>
References: <tip-efb3d17240d80e27508d238809168120fe4b93a4@git.kernel.org>
Date: Sat, 30 May 2009 09:15:20 +0900
Message-ID: <49b7c2350905291715v2ff53a96o98a0fd195ee27dc9@mail.gmail.com>
Subject: Re: [tip:perfcounters/core] perf_counter: Fix COMM and MMAP events 
	for cpu wide counters
From: GeunSik Lim <leemgs1@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, May 30, 2009 at 2:16 AM, tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  efb3d17240d80e27508d238809168120fe4b93a4
> Gitweb:     http://git.kernel.org/tip/efb3d17240d80e27508d238809168120fe4b93a4

I have one question about "tip-bot" and "-tip" word.
"tip" word is abbreviation. Can anyone explain me meaning  of the "tip" word?
Sorry for trivial question.
But I always wondered about this abbreviation in private.


-- 
Regards,
GeunSik Lim ( SAMSUNG ELECTRONICS)
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
