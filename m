Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXAWNIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXAWNIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964999AbXAWNIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:08:14 -0500
Received: from il.qumranet.com ([62.219.232.206]:43953 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbXAWNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:08:14 -0500
Message-ID: <45B608BB.4020500@qumranet.com>
Date: Tue, 23 Jan 2007 15:08:11 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] KVM: propagate SHUTDOWN intercept to userspace on SVM
References: <20070123125029.GA7919@amd.com>
In-Reply-To: <20070123125029.GA7919@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch implements forwarding of SHUTDOWN intercepts from the guest
> on to userspace on AMD SVM. A SHUTDOWN event occurs when the guest produces
> a triple fault (e.g. on reboot). This also fixes the bug that a guest
> reboot actually causes a host reboot under some circumstances.
>
>   

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function

