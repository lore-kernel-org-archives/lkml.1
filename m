Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYBJMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYBJMDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYBJMDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:03:42 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:48717
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYBJMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:03:41 -0500
Message-ID: <47AEE81C.4040803@qumranet.com>
Date: Sun, 10 Feb 2008 14:03:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] KVM: add support for SVM Nested Paging
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,
>
> here is the improved patchset which adds support for the Nested Paging
> feature of the AMD Barcelona and Phenom processors to KVM. The patch set
> was successfully install- and runtime-tested with various guest
> operating systems (64 bit, 32 bit legacy and 32 bit PAE Linux,
> Windows 64 bit and 32 bit versions too).
>
>   

Applied all, thanks.


-- 
error compiling committee.c: too many arguments to function

