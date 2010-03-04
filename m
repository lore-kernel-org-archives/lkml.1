Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0CDOyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:54:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46268 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0CDOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=u5YBghhnuLHAyWyqNP5fxZZZ5E7o9ikeR0nRzRA80W/MIEb4aLUw6EV2kAGyrWLCGQ
         S8cJRoMrwL39i1cuA+P5eYXWGddvzpi0dtthiWTuxNHqcmuTwyaEZq71Bb5rYwX1N9YO
         cfkQNVZOzSQdTSKeDwQlqOp0CxZVuB/cA0kbc=
Message-ID: <4B8FC98E.3070203@gmail.com>
Date: Thu, 04 Mar 2010 15:54:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: mmotm 2010-03-02-18-38 uploaded
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
In-Reply-To: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 03:39 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to

Hi, the kernel does not boot in qemu-kvm with NO_BOOTMEM=y. The last
message is 'Booting the kernel.'

thanks,
-- 
js
