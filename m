Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbXC3COt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbXC3COt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXC3COt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:14:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:25788 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbXC3COs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=N0Y5iPn2xwsuU58fS16LPCjNogF4AF9NDF7yB9vZgSQajeoZyAfKSdrk6rsyYhEZcfr1zDDd0DV0/X3wtN6zlQTCdVbHLsjlEzmuoLC0UokUWp6pLfSWTxEUc4Kwna++tCx6K1UaN/hq2/9daqwhEepQfjTPKcUFzkAWJkVbtWQ=
Message-ID: <75b66ecd0703291914n551b49d8n93cfbb3374ba8752@mail.gmail.com>
Date: Thu, 29 Mar 2007 22:14:46 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Elliott Johnson" <ejohnson@linuxmail.org>
Subject: Re: strange high system cpu usage.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070329222221.9C53BCA0A4@ws5-11.us4.outblaze.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070329222221.9C53BCA0A4@ws5-11.us4.outblaze.com>
X-Google-Sender-Auth: 86df4c318bf446a1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Elliott Johnson <ejohnson@linuxmail.org> wrote:
> Hello,
>
> I've been upgrading a few machines here at work and noticed some problems with high system cpu usage on one machine.  In trying to debug the problem I've come across a few confusing stats that I was hoping could be cleared up by someone on this list.

What problem are you trying to solve?  IOW, how do you know it's not
just an artifact of diferent load average calculation between 2.4 and
2.6?

Are you actually seeing reduced throughput/performance?  Or are you
just looking at load average?

Lee
