Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXC3FF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXC3FF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXC3FF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:05:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:25823 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbXC3FFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f/holFXjNoxqXYHlK8D5nZboVxXBhz+c7n1lF8kp+ov9EsKku3zkiX+Mtys++dxZWsIe+Qo4hEQBC7uuZjWDLLAZyGSMlFLfCRakUNWOjqYuwkVEIsesQugqF+8yS1xU3G36qmB5BJqtIvhQriZfwQaeHHrZ+reeRKmiTPoE8+E=
Message-ID: <75b66ecd0703292205g6e8f1e99r1985b0a421d4d593@mail.gmail.com>
Date: Fri, 30 Mar 2007 01:05:24 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Aubrey Li" <aubreylee@gmail.com>
Subject: Re: [Quick question] serial core issue
Cc: rmk@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6d6a94c50703292052p2181cc89l2e217cd05ed36221@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d6a94c50703292052p2181cc89l2e217cd05ed36221@mail.gmail.com>
X-Google-Sender-Auth: 0e78423660d35714
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Aubrey Li <aubreylee@gmail.com> wrote:
> When register serial driver as a console, the driver function
>
> my_remove()
> my_shutdown()
>
> seems be never called.
>
> So the driver can't reclaim resource when the command "reboot" is issued.
>
> Is it intended?

Please post your code for review and someone can probably help.

Lee
