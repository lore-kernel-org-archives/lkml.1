Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbYBOWey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbYBOWey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763794AbYBOWcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:32:52 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:42480 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762499AbYBOWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=adNPT2jJVEhaOt3TAD8cN5Kf/lBeI3sm1UX9GTEJ9bjw3LHemj3CWCx5QoMo2Ot3Dt+wkbpmAvAAuaomWEdSzFAophgU4fOqRWrFnqM0uWZznbWkAUuLPxubG6bswB/vmNze2+SCc0Ihe+wjUFUY1CXIeG7ThJLNm1nm2N6fzm4=
Message-ID: <43e72e890802151432v2729bb58j505cf3994c623d2e@mail.gmail.com>
Date: Fri, 15 Feb 2008 17:32:48 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] WDEV: ath5k, typecheck on nonDEBUG
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       "Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <1203109133-32217-3-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
	 <1203109133-32217-3-git-send-email-jirislaby@gmail.com>
X-Google-Sender-Auth: 18db6a6d481563c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 3:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> At least type check the ATH5K_TRACE paramter on !ATH5K_DEBUG configs.

That's pretty cool.

>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
