Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZCKNO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZCKNO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZCKNOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:14:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41110 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbZCKNOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:14:39 -0400
Message-ID: <49B7B939.6070009@redhat.com>
Date: Wed, 11 Mar 2009 15:14:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: make 'lapic_timer_ops' and 'kpit_ops' static
References: <20090310215053.11822.79188.stgit@f10box.hanneseder.net>
In-Reply-To: <20090310215053.11822.79188.stgit@f10box.hanneseder.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Fix this sparse warnings:
>   arch/x86/kvm/lapic.c:916:22: warning: symbol 'lapic_timer_ops' was not declared. Should it be static?
>   arch/x86/kvm/i8254.c:268:22: warning: symbol 'kpit_ops' was not declared. Should it be static?
>
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

