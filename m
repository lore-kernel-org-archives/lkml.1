Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZGAIQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZGAIQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGAIP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:15:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGAIP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:15:58 -0400
Message-ID: <4A4B1BA8.6070109@redhat.com>
Date: Wed, 01 Jul 2009 11:17:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix lock imbalance
References: <1246291510-3676-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1246291510-3676-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 07:05 PM, Jiri Slaby wrote:
> There is a missing unlock on one fail path in ioapic_mmio_write,
> fix that.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

