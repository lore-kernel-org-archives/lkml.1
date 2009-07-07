Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZGGUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZGGUxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZGGUxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:53:14 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54804 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZGGUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gdU2LSyuUStPmcTG7WsnL1yEvfXbhl+wuLAyAqu7d9L1uXuljYFxECuROCgeoFd9DE
         xPmsxY6Ath7mz5qJcZVU3fs/KKoSEcScjavzlxPBoJOeoTVi7i5eYLHoxPlgxEmbjk9o
         rilajzV+Far4JgnMN91Y4wlhtAyNOtdJo/kd8=
Message-ID: <4A53B5B4.9070909@gmail.com>
Date: Tue, 07 Jul 2009 22:53:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc2: irq 16: nobody cared
References: <4A524328.6020503@gmail.com>
In-Reply-To: <4A524328.6020503@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2009 08:32 PM, Niel Lambrechts wrote:
> Jul  6 09:45:01 localhost kernel: handlers:
> Jul  6 09:45:01 localhost kernel: [<f8720213>] (yenta_interrupt+0x0/0xb9
> [yenta_socket])
> Jul  6 09:45:01 localhost kernel: Disabling IRQ #16

Is there only yenta for irq 16 in /proc/interrupts before resume?
