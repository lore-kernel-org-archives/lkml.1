Return-Path: <linux-kernel-owner+w=401wt.eu-S937428AbXGTWTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937428AbXGTWTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbXGTWSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:18:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:60671 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761860AbXGTWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BxD8UlWtVnKzTYljkI9k5HzH3PLT0X/ElgBoPcWi9rpMpbZ8cFNUPvWbl9FmScBzJ6ihwQn5LlWOlw6/3KU9nzhXTiI0MXNgo6L6A6bF217FZRV6odoD4nW9JZA6Y9owzc7oSTj2ye4rK7VJQVpmlCoBN0TOky5iyjWhGf4YFBc=
Message-ID: <75b66ecd0707201518j45ef8bb7q7e48462ffbbc9c58@mail.gmail.com>
Date: Fri, 20 Jul 2007 18:18:51 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: posible latency issues in seq_read
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46A125F4.3030504@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A125F4.3030504@nortel.com>
X-Google-Sender-Auth: b76fc6178dfe31d2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Chris Friesen <cfriesen@nortel.com> wrote:
>
> We've run into an issue (on 2.6.10) where calling "lsof" triggers lost
> packets on our server.  Preempt is disabled, and NAPI is enabled.
>

Can you reproduce with a recent kernel?  Lots of latency issues have
been fixed since then.

Lee
