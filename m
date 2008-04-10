Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYDJGFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYDJGFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYDJGFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:05:23 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:51126 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYDJGFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i2f/EVE1eEHEPFroPKathYOuBtLK2fNJJ6/X8GWfmakdvFm0rUIndHdxn21wfXom4YJnPAm0wzs2pQhiOlXrClbD8VQEQes1N3hUThsAZJn6N4R6Hvbi8t6/UUqYd3f7EKFWXwPsWPLM42JjnvrcGEMBA4hQ7N8m/j7H6El2Ehs=
Message-ID: <36ca99e90804092305m6152fc85m42b599b4bfa304ff@mail.gmail.com>
Date: Thu, 10 Apr 2008 08:05:21 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 3/3] cpumask: add show cpu map functions v2
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080409192901.a074dc35.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <20080408184302.113424000@polaris-admin.engr.sgi.com>
	 <36ca99e90804081232iff9b19fp41e76c04cf140446@mail.gmail.com>
	 <47FBDB0D.1010202@sgi.com>
	 <36ca99e90804091039v6e1ad966yd738ed88b267f315@mail.gmail.com>
	 <20080409192901.a074dc35.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 2:29 AM, Paul Jackson <pj@sgi.com> wrote:
> Bert wrote:
>  > PS: this is the only source I found for the libbitmask(3):
>
>  Mike has been mentioning libbitmask as if it were readily
>  available outside SGI.  That's not entirely true, yet.
>
>  SGI delivers libbitmask as part of its products to its
>  customers under an LGPL license, and I provide libbitmask
>  sources to others on request.  Real Soon Now (tm) I will
>  be publishing libbitmask sources on our oss.sgi.com web
>  site for one and all to make use of, under LGPL license.
>  But I haven't done that ... yet.
>
>  Libbitmask is a user level library, similar in purpose to,
>  but quite different in internal implementation and API
>  details from, the bitmap, cpumask and nodemask types in
>  the kernel.
>
>  A second library, libcpuset, is also delivered by SGI under
>  LGPL license, and provides a rich C library for use by
>  major applications requiring a robust cpuset interface.
>  This library too should become more easily obtained, once
>  I get around to publishing it on oss.sgi.com.
Thank you for this information.

Bert
>
>  --
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.940.382.4214
>
