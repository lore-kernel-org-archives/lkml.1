Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZJASdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZJASdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbZJASdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:33:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbZJASdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:33:35 -0400
Message-ID: <4AC4F5E8.6010802@zytor.com>
Date: Thu, 01 Oct 2009 11:33:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com> <20090922143223.GA31702@elte.hu> <4AB8EAF2.1030204@zytor.com> <4AC4C8F2.5050708@redhat.com> <4AC4C9D5.3000902@zytor.com> <4AC4CB2A.4000908@redhat.com>
In-Reply-To: <4AC4CB2A.4000908@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 08:30 AM, Avi Kivity wrote:
> 
> While I'd prefer it to be in .32, as there's much churn in both trees, I 
> guess we should follow the process and schedule it for .33.
> 

OK, sounds like a plan.  I'll pull it into -tip.

	-hpa
