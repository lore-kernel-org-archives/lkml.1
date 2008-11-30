Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbYK3Uo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbYK3Uo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 15:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYK3Uoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 15:44:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57114 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbYK3Uoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 15:44:46 -0500
Message-ID: <4932FB47.6090300@redhat.com>
Date: Sun, 30 Nov 2008 22:44:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades>
In-Reply-To: <20081130203833.GA14903@hades>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques wrote:
> No, I was not able to reproduce the issue.  Please let me know if you need some
> more information on my system (.config, for instance).
>   

Were you using some other virtualization product?  Were you running 
suspend/resume?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

