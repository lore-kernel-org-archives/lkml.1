Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZGBPsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZGBPsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZGBPsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:48:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46348 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZGBPsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:48:05 -0400
Message-ID: <4A4CD729.6050300@redhat.com>
Date: Thu, 02 Jul 2009 18:50:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
References: <20090702153454.20186.99191.stgit@dev.haskins.net>
In-Reply-To: <20090702153454.20186.99191.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2009 06:37 PM, Gregory Haskins wrote:
> (Applies to kvm.git/master:1f9050fd)
>
> The following is the latest attempt to fix the races in irqfd/eventfd, as
> well as restore DEASSIGN support.  For more details, please read the patch
> headers.
>
> As always, this series has been tested against the kvm-eventfd unit test
> and everything appears to be functioning properly. You can download this
> test here:
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

