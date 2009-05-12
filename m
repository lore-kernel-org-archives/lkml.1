Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZELIce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZELIce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZELIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:32:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37543 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbZELIcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:32:14 -0400
Message-ID: <4A0933D9.5090305@redhat.com>
Date: Tue, 12 May 2009 11:31:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] kvm: fix build error: add missing semi-colon
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au> <4A085326.3030707@oracle.com>
In-Reply-To: <4A085326.3030707@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add missing ; to fix build error:
>
> arch/x86/kvm/x86.c:1259: error: expected',' or ';' before 'const'
>
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

