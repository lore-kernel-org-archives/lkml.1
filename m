Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0CHAJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 19:09:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51487 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab0CHAJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 19:09:05 -0500
Message-ID: <4B944006.1090602@zytor.com>
Date: Sun, 07 Mar 2010 16:08:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com> <20100301174724.GA12867@redhat.com> <4B8C09F5.9070506@redhat.com> <20100301190341.GD12867@redhat.com> <4B8C1320.6060602@redhat.com> <4B8C4032.7080703@zytor.com> <4B8C463B.7070900@zytor.com> <20100302084907.GV16909@redhat.com> <4B936C1F.4060504@redhat.com>
In-Reply-To: <4B936C1F.4060504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 01:04 AM, Avi Kivity wrote:
>
> The setjmp/longjmp implementation should definitely live in arch/*/lib,
> even if kvm is the only user.
>

Obviously.

	-hpa
