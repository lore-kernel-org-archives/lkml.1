Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZKFA4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZKFA4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZKFA4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:56:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbZKFA4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:56:13 -0500
Message-ID: <4AF37425.9060000@zytor.com>
Date: Thu, 05 Nov 2009 16:56:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 09/11] sysctl: x86 Use the compat_sys_sysctl
References: <m1tyx8trik.fsf@fess.ebiederm.org> <1257468114-6823-9-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1257468114-6823-9-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2009 04:41 PM, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that we have a generic 32bit compatibility implementation
> there is no need for x86 to implement it's own.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

I'm assuming based on your previous email that you'll hang on to this
patch and carry it yourself.

	-hpa
