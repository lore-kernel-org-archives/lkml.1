Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0BGLuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:50:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab0BGLuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:50:19 -0500
Message-ID: <4B6EA84D.20500@redhat.com>
Date: Sun, 07 Feb 2010 13:47:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/11] arch/x86/kvm: Correct NULL test
References: <Pine.LNX.4.64.1002060942390.8092@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1002060942390.8092@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2010 10:43 AM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> msr was tested above, so the second test is not needed.
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

