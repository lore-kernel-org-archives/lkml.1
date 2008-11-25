Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYKYOcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYKYOcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYKYOcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:32:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40308 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYKYOco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:32:44 -0500
Message-ID: <492C0C84.2040508@redhat.com>
Date: Tue, 25 Nov 2008 16:32:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH] sign kvmclock as paravirt
References: <1227548723-18117-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1227548723-18117-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Currently, we only set the KVM paravirt signature in case
> of CONFIG_KVM_GUEST. However, it is possible to have it turned
> off, while CONFIG_KVM_CLOCK is turned on. This is also a paravirt
> case, and should be shown accordingly.
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

