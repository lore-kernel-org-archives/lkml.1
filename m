Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbXBRJUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbXBRJUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 04:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXBRJUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 04:20:33 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:32602 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933121AbXBRJUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 04:20:33 -0500
Message-ID: <45D81A5C.3020808@qumranet.com>
Date: Sun, 18 Feb 2007 11:20:28 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM SVM: intercept SMI to handle it at host level
References: <20070216150929.GA27093@amd.com>
In-Reply-To: <20070216150929.GA27093@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2007 09:20:32.0358 (UTC) FILETIME=[09F69060:01C7533E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
>
> This patch changes the SVM code to intercept SMIs and handle it
> outside the guest.
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

