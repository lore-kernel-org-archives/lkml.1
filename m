Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbYK3KQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbYK3KQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 05:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYK3KQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 05:16:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYK3KQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 05:16:04 -0500
Message-ID: <493267DB.90303@redhat.com>
Date: Sun, 30 Nov 2008 12:15:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] KVM: VMX: fix sparse warning
References: <49304b16.0ab6660a.0d69.ffff9a04@mx.google.com>
In-Reply-To: <49304b16.0ab6660a.0d69.ffff9a04@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Impact: make global function static
>
>   arch/x86/kvm/vmx.c:134:3: warning: symbol 'vmx_capability' was not declared. Should it be static?
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

