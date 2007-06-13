Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXFMSxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXFMSxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXFMSx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:53:26 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:51690 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXFMSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dmgZuZsxce7ZlrfzSBUzlbWf5tM2eyqUD1k4zdNE4fxqZ39LWmtn+sEf29Po7t5UTerxs678+nb64R8iL94e0s5YCrkZdqjmaL1vskhLIWkk+6IdwNu70qrXsTMvn4exuO8QwJVa7gbnrD6fJgR5T0xuyMevfPo2WdcYhqAekqU=
Message-ID: <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
Date: Wed, 13 Jun 2007 11:53:22 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: raid5: coding style cleanup / refactor
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
	 <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
X-Google-Sender-Auth: 55e0283b662d9024
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In other words, it seemed like a good idea at the time, but I am open
> to suggestions.
>

I went ahead and added the cleanup patch to the front of the
git-md-accel.patch series.  A few more whitespace cleanups, but no
major changes from what I posted earlier.  The new rebased series is
still passing my tests and Neil's tests in mdadm.

--
Dan
