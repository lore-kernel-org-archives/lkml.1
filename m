Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZDCDhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZDCDhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZDCDhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:37:39 -0400
Received: from gw.goop.org ([64.81.55.164]:52293 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZDCDhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:37:38 -0400
Message-ID: <49D5847F.304@goop.org>
Date: Thu, 02 Apr 2009 20:37:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nitin A Kamble <nitin.a.kamble@intel.com>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: paravirtops kernel and HVM guests
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com>	 <49C1665A.4080707@goop.org> <49C16A48.4090303@redhat.com>	 <49C17230.20109@goop.org> <49C17880.7080109@redhat.com>	 <49C17BD8.6050609@goop.org> <49C17E22.9040807@redhat.com>	 <49C18487.1020703@goop.org> <1238726501.6208.6.camel@mukti.sc.intel.com>
In-Reply-To: <1238726501.6208.6.camel@mukti.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin A Kamble wrote:
> Jeremy,
>   I was trying the latest bits from your paravirtops tree with
> xen-unstable. Dom0 is booting fine in Fedora 10 environment. I am seeing
> page fault handing error while trying to create an HVM guest. 
> Is anybody working on the HVM support on top of paravirtops kernel?
>   

Yes, that's how it fails at the moment; that debug message is from the 
last time I tried to track down what's going wrong, but I haven't 
managed to make any progress beyond that.   Getting it working is a 
fairly high priority; I'll probably have another look at it next week.

    J
