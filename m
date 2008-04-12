Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYDLOEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYDLOEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 10:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYDLOEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 10:04:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:55636 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYDLOEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 10:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nmtSNFcx/h62K4Qe7nGO8iTfO+ziqpsRjrcfWIgq9GQvxumhLPJuDa0B0/cj1l/A7YNkHVs2whkjNTz6619/WzDNiSIkUKXi0DdtobHfvcWcPOZbyYnWgekf79jLfDl2V4uHuo3UvCNI/vVZXmumb32qQh+0IdlzSxxBiMoHL7A=
Message-ID: <4800C14C.5060507@gmail.com>
Date: Sat, 12 Apr 2008 16:03:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: fix exec mappings comments
References: <1207988905-17806-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1207988905-17806-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2008 10:28 AM, Jiri Slaby wrote:
> - noexec32 is on by default for years already
> - add noexec32 to kernel-parameters and fix noexec type in there

I meant "typo".
