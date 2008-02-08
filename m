Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYBHWW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYBHWW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYBHWWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:22:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:36958 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYBHWWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:22:18 -0500
Message-ID: <47ACD614.2080000@codemonkey.ws>
Date: Fri, 08 Feb 2008 16:22:12 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] KVM binary incompatiablity
References: <20080208113236.55b2ead1@extreme>
In-Reply-To: <20080208113236.55b2ead1@extreme>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> I notice that recent KVM is incompatiable with older versions.
>
> Using a KVM image created on 2.6.24 will crash on 2.6.25 (or
> vice versa). It appears that Ubuntu Hardy has incorporated the 2.6.25
> update even though it claims to be 2.6.24.
>   

This isn't intentional.  What is the guest and how does it crash?

I've been using the same image for most of KVM's development life cycle 
without having issues.

Regards,

Anthony Liguori

> This is reproducible on Intel (64bit) kernel.  Was this intentional?
> is it documented? 
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>   

