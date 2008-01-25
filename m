Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYAYKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYAYKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYAYKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:25:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:10469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYAYKZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kk8jRlX+7a9hGsgJY2xt/Er/BQ3+P/v5GMDOdv4t13jYJjm0gwrTFnRmxsaY5BdrENZjA5PV1zn0FPIRX/NqFwgu68fGv38a1H4zFNJlHJssyrsI2dJ3iGiDL/gLO9AzrzNXmT2usecasVXjSUrPo5h2ZtpFp5tgRRHOB1RWOGQ=
Message-ID: <4799B906.5000607@gmail.com>
Date: Fri, 25 Jan 2008 13:25:10 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 0/9] bfs: assorted cleanups
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev пишет:
> Hello Adrian,
> 
> Last time when I had sent some BFS bugfixes to the maintainer of
> this filesystem driver, he did not respond, and Andrew Morton
> had to take care of those.
> 
> For this reason, and because the patches in this little patch bomb
> are trivial, I am sending this to you in the hope that these can
> be pushed upstream when the next merge window opens.

Adrian, please drop this version of the patches. I'll send you a new
one addressing the feedback and indicating the ack I received from the
driver maintainer in a private email.

Thanks,

Dmitri
