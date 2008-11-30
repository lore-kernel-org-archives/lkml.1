Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYK3VEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYK3VEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 16:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYK3VEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 16:04:14 -0500
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:43961 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753327AbYK3VEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 16:04:13 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sun, 30 Nov 2008 21:04:06 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
Message-ID: <20081130210406.GA17952@hades>
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4932FB47.6090300@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 10:44:55PM +0200, Avi Kivity wrote:
> Luis Henriques wrote:
>> No, I was not able to reproduce the issue.  Please let me know if you need some
>> more information on my system (.config, for instance).
>>   
>
> Were you using some other virtualization product?  Were you running  
> suspend/resume?

No for both questions.  However, I had compiled support for suspend (not sure if
this is what you mean by "running suspend/resume") - This is a feature I used
only once or twice...

-- 
Luis Henriques
