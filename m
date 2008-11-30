Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbYK3KSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbYK3KSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 05:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYK3KSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 05:18:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYK3KSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 05:18:08 -0500
Message-ID: <49326857.2030501@redhat.com>
Date: Sun, 30 Nov 2008 12:17:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] KVM: fix sparse warning
References: <49304b32.0baa660a.462a.ffffb75d@mx.google.com>
In-Reply-To: <49304b32.0baa660a.462a.ffffb75d@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Impact: make global function static
>
>   virt/kvm/kvm_main.c:85:6: warning: symbol 'kvm_rebooting' was not declared. Should it be static?
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

