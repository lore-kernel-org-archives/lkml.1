Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbZHDXZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbZHDXZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbZHDXZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:25:53 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:49547 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510AbZHDXZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qFvqufbGjGp9gg6lWc3Mqid9Z1AHqEbyn45xma9a0bPXaO2AOU4+lSK7Nr4dDDcByR
         K4KjpVZmn+DBuu1xi74dzfvYkKmbInwT1KkYDK9BhqWXQ8nUg+s8JY0LMq9hPdDCa8md
         YUnAD93mkiT8s43bFRqrvHptEJNnXKz+tkHog=
Message-ID: <4A78C37D.4070805@gmail.com>
Date: Tue, 04 Aug 2009 17:25:49 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ken Mandelberg <km@mathcs.emory.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Panic with 2 quad opterons (2346)
References: <4A77585E.6020307@mathcs.emory.edu>
In-Reply-To: <4A77585E.6020307@mathcs.emory.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 03:36 PM, Ken Mandelberg wrote:
> I've been trying to upgrade a box that had two dual opteron, to two quad
> opterons (2346). The motherboard and firmware is documented as
> supporting this.
>
> I've tried the latest Ubuntu and Centos distributions.
>
> With 32 bit kernels, the two quad cores work fine.
>
> With 64 bit kernels, and only one quad core inserted it works fine.
>
> With both quad cores, the 64 bit kernels panic immediately.
>
> In all tests there are 4 2GB dimms , 2 in each in bank.
>
> Any thoughts?

Can you get the panic text at least partially?
