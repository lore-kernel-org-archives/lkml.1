Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYFBG56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYFBG56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFBG5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:57:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:32851 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYFBG5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OsE2aCRXkx9tXV4UQOj0S+qSOAVc9RR7mthYSjjHKrPw5gXM127TQ1GU+eYtZ66ITJGb0BdRA4dNjvjrHIIk/56nDsJeGgZ0u44RI2E8AvgLxOql9HI+nQqI6031c1RkvXOeeoSYImHFnZn7dftD1t0T0QOf0aVYCQgX+6nEUj8=
Message-ID: <a8e1da0806012357g229f2734v83bf06d885e61876@mail.gmail.com>
Date: Mon, 2 Jun 2008 14:57:47 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] bluetooth: rfcomm_dev_state_change deadlock fix
Cc: marcel@holtmann.org, arjan@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <20080601.235018.266140984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080602014625.GA2893@darkstar.te-china.tietoenator.com>
	 <E5C422A2-82BC-4E9E-B113-835A11AB8CBD@holtmann.org>
	 <20080601.235018.266140984.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 2:50 PM, David Miller <davem@davemloft.net> wrote:
> From: Marcel Holtmann <marcel@holtmann.org>
> Date: Mon, 2 Jun 2008 08:15:03 +0200
>
>> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>
> Applied, but I had to add the commit header string to the two SHA ID
> commit references.  Please always provide the header line text as well
> as the SHA ID when referencing commits because when backporting or
> putting the patch into a different tree the SHA ID will be different
> and people will have a terrible time trying to find the commits you
> are referring to.

Will do next time, thanks.

>
> Thanks.
>



-- 
---
Regards
dave
