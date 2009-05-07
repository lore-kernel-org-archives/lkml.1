Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZEGTqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZEGTqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZEGTpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:45:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZEGTpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:45:49 -0400
Message-ID: <4A033A16.1090104@redhat.com>
Date: Thu, 07 May 2009 22:44:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Gregory Haskins <ghaskins@novell.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <20090507190751.GE3036@sequoia.sous-sol.org> <4A033281.8050002@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org> <4A0335CB.5010408@redhat.com>
In-Reply-To: <4A0335CB.5010408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> I think we just past the "too complicated" threshold.
>

And the "can't spel" threshold in the same sentence.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

