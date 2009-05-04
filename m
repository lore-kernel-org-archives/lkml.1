Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZEDI2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZEDI2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZEDI15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:27:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZEDI14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:27:56 -0400
Message-ID: <49FEA6E7.4080006@redhat.com>
Date: Mon, 04 May 2009 11:27:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix apic_debug instances
References: <1241040549-25963-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1241040549-25963-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Appearently nobody turned this on in a while...
> setting apic_debug to something compilable, generates
> some errors. This patch fixes it.
>
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

