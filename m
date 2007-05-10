Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbXEJVmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbXEJVmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbXEJVlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:41:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448AbXEJVll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:41:41 -0400
Message-ID: <46439185.5060207@redhat.com>
Date: Thu, 10 May 2007 17:41:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org>
In-Reply-To: <46426194.3040403@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> David Chinner wrote:
>> Seems very unlikely. Have you unmounted and mounted the filesystem
>> (or rebooted or suspended) between the files being seen good and
>> the files being seen bad?
>>   
> 
> There was definitely a suspend-resume, and maybe a reboot.  I'll try
> again later on.
> 

What CPU architecture is this happening on? Not i686 with PAE by
any chance?
