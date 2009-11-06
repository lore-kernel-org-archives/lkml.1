Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbZKFBPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbZKFBPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZKFBPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:15:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50375 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbZKFBPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:15:15 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 09/11] sysctl: x86 Use the compat_sys_sysctl
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<1257468114-6823-9-git-send-email-ebiederm@xmission.com>
	<4AF37425.9060000@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Nov 2009 17:15:16 -0800
In-Reply-To: <4AF37425.9060000@zytor.com> (H. Peter Anvin's message of "Thu\, 05 Nov 2009 16\:56\:05 -0800")
Message-ID: <m14op8tpwb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 11/05/2009 04:41 PM, Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Now that we have a generic 32bit compatibility implementation
>> there is no need for x86 to implement it's own.
>> 
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
> I'm assuming based on your previous email that you'll hang on to this
> patch and carry it yourself.

That's the plan.

Eric

