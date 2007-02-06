Return-Path: <linux-kernel-owner+w=401wt.eu-S965156AbXBFAL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156AbXBFAL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965220AbXBFAL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:11:57 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:23409 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbXBFALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fRgCbCCCCVdUg5qcqfTuPuJHt0Hc8Y3YSGQPzOLYko8eHWs9UaA7hcEUe50K0pouG/9ewsDQKePJYMybP/XE64jq6AesK7Ctk3dCnq2wQarASlxh1PWxBpLm3A00zXkhKPiJcrkKcPDpT8KlKkNKZeXNNZL/e/vvO/zEpnYN6bk=
Message-ID: <6bffcb0e0702051611j23c4f160s61196a3c378c38e2@mail.gmail.com>
Date: Tue, 6 Feb 2007 01:11:53 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: v2.6.20-rt1, yum/rpm
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070205065636.GA1652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070205065636.GA1652@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/07, Ingo Molnar <mingo@elte.hu> wrote:
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the
> usual place:
>
>   http://redhat.com/~mingo/realtime-preempt/
>

-rt2 vs. autotest.

Good news - It passes aiostress, linus_stress and ltp.

Bad news - it hangs a few seconds after pi_tests (I don't see any
errors in /var/log/messages)

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
