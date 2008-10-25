Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYJYIGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYJYIGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYJYIFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:05:48 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:3533 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYJYIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UgeZz88SWgJJpN6j1+bMMt2iXHteHCx3KPDlb8CmRcRkCw/UK0CwnSOiQ8vYooag1W
         HK2oYOjVVa+jivsDVVfn9eW+WSN1+OGVYiJ7B5anhlToFieWxqsnafWN96WOKNJZlGOa
         Uh1anfrJ2PXd6v1+EkSH3hoLFilyzHvfK1vqY=
Message-ID: <2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
Date: Sat, 25 Oct 2008 17:05:40 +0900
From: "Dong-Jae Kang" <baramsori72@gmail.com>
To: "Matthew Garrett" <mjg@redhat.com>
Subject: Re: [Question] power management related with cgroup based resource management
Cc: balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       corsetproject@googlegroups.com,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20081024232503.GA20140@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
	 <4901B5C2.9070108@linux.vnet.ibm.com>
	 <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
	 <20081024232503.GA20140@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your positive opinion about my question

I also hope cgroup framework has good point related with power management
I think I need more re-consideration for it. ^^

How do you think about cgroup based management of new HW devices, for
example, SSD, NVRAM and so on.
Is there any requirement for it ?
and is there any required work for it?
I didn't seriously consider  about that until now.^^ so I don't have cool idea
but, I think it is worthy to find new domain to be applied by existing
technology

thank you.

Best Regards,
Dong-Jae Kang

2008/10/25 Matthew Garrett <mjg@redhat.com>:
> On Fri, Oct 24, 2008 at 09:24:21PM +0900, Dong-Jae Kang wrote:
>
>> I am interested in power management in server side.
>> and I just wonder this question, "Is there any related point between
>> cgroup framework and power management?"
>
> Not currently, though it would certainly be possible to use cgroups as a
> mechanism for providing application-specific power management.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>



-- 
-------------------------------------------------------------------------------------------------
   DONG-JAE, KANG
   Senior Member of Engineering Staff
   Internet Platform Research Dept, S/W Content Research Lab
   Electronics and Telecommunications Research Institute(ETRI)
   138 Gajeongno, Yuseong-gu, Daejeon, 305-700 KOREA
   Phone : 82-42-860-1561 Fax : 82-42-860-6699
   Mobile : 82-10-9919-2353 E-mail : djkang@etri.re.kr (MSN)
-------------------------------------------------------------------------------------------------
