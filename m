Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0CKXll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:41:41 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:29846 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0CKXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qyrjaSK8Xi1wHMwMD49etfvHmiT2RHsvZjhc97Y6w0aY4Maq+hqZpQhWdHYn9+TZDc
         shDGY+nHmY9LvynjTor8W0dbjBpQHCVvSfsCgFCy4pr000neOyBL2HAIK+hK+Cs+q4dF
         gYJxu3Az2Ke5dVJV7RC0EcC+HJROK2P19bJLw=
Message-ID: <4B997FB1.3000404@garzik.org>
Date: Thu, 11 Mar 2010 18:41:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Benton <b3nton@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata2: lost interrupt with kernel 2.6.34-rc1
References: <4B992110.2090300@gmail.com>
In-Reply-To: <4B992110.2090300@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 11:57 AM, Andrew Benton wrote:
> Hello,
> I'm not subscribed to this list, sorry if it's the wrong place to send
> this.
> I've been having problems with 2.6.34-rc1, when the system tries to
> access a
> lot of files (eg, if I recompile the kernel) it freezes for about 10
> seconds
> or so and then I get a message like this in the sys.log:

Does 2.6.33 also have this behavior?

	Jeff



