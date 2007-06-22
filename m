Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbXFVLj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbXFVLj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXFVLjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:39:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:56409 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXFVLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ImtdEAHZkZ8ewsOkv3XaPFPwdd6sjjX4ErNCsra1LdSP2w28DSPPaN3Rt1/uzsh7ah0t2yOAczs6tLq5nUOP7boAwHgwDtxE7GFLpafhbMcRQnMIykCSx+1T/nXOt2uFrXl6J72KOZVESRv9mbxo35BsbuqnWyxRh46cdsIq5ls=
Message-ID: <a9e22dff0706220439m4bc70a30i8cc83fe92cff8bc9@mail.gmail.com>
Date: Fri, 22 Jun 2007 14:39:50 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches v2
In-Reply-To: <6bffcb0e0706220427p203de10epeaa6e97d3f63886d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467AA8CA.2020206@googlemail.com>
	 <a9e22dff0706220259y6b2cec29s8f5e059ba8c42b77@mail.gmail.com>
	 <6bffcb0e0706220427p203de10epeaa6e97d3f63886d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We have patches for "very high non-preempt latency in
> context_struct_compute_av()" and "list_add corruption. prev->next
> should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug
> at lib/list_debug.c:33", but both are too intrusive.
>
> Anyway, those bugs are not regressions.
>

Are you going to release 2.6.22 with this bugs?? But question wasn't
on this subject ...
The question was "why linux kernel release should have some bugs that
would be fixed fixed in future?"
Let's wait and publish kernel w/o known bugs. Let's wait for some
time, let's publish 2.6.22-rc_last, test it for some time(2 weeks for
example), fix bugs if any and after _test_period_of_whole_kernel_ but
not _separate_patches/parts_ of kernel release stable one!
