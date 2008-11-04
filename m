Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYKDQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYKDQzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYKDQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:55:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbYKDQzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:55:13 -0500
Message-ID: <49107E2C.8090803@redhat.com>
Date: Tue, 04 Nov 2008 18:54:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> Hi,
>
> This is a new version of the series to disabling virtualization on kdump,
> now extended to do the same tricks on emergency_restart() if needed.
>   

Looks good.  If you me to push it upstream, I'll need kexec/kdump acks.  
Otherwise, ack for the kvm bits.

-- 
error compiling committee.c: too many arguments to function

