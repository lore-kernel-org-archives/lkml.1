Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYJXMYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYJXMYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYJXMYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:24:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:17704 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYJXMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Kh+Eogk/jG+trQjxEfCb4uuIp+3bQ/GLdshOSHFPO8SlLHABQclA2mHlV2goZaRCE3
         7rrcy2XzE0YvfzzgexjJ+HxZM7p+dInOteVs7iDc0IbRr/F4wyQ8tFRcH3zljSvh/C+G
         7Ovnr4mMcteGldy1dXRps30srImxnHof8Z+jo=
Message-ID: <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
Date: Fri, 24 Oct 2008 21:24:21 +0900
From: "Dong-Jae Kang" <baramsori72@gmail.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [Question] power management related with cgroup based resource management
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, corsetproject@googlegroups.com,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <4901B5C2.9070108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
	 <4901B5C2.9070108@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Balbir Singh

2008/10/24 Balbir Singh <balbir@linux.vnet.ibm.com>:
> Dong-Jae Kang wrote:
>> Hi, all
>>
>> These days, I am interested in green IT area for low power OS
>> So, I have a question about it.
>> Is there any good idea or comments about power management related with
>> cgroup based resource management?
>> I have no idea about that, but it seems to be possible to find a good concept.
>> And I hope so
>> Is it some strange question? ^^
>
> lesswatts.org, linux-pm (mailing list) are good sources on Power Management. I
> would recommend asking at those mailing lists (there are several new features
> like range timers, no idle hertz, sched_mc consolidation and much more). Could
> you be specific about what you are looking for? Are you looking at
> Server/Desktop power management?
>

Thank you very much for your kind recommendation.^^
this site information will be helpful for me.
As your recommendation, I will try to contact to lesswatts.org,
linux-pm (mailing list)

I am interested in power management in server side.
and I just wonder this question, "Is there any related point between
cgroup framework and power management?"

Thanks again

Regards,
Dong-Jae Kang
