Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYATRSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYATRSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 12:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYATRSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 12:18:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:15665 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYATRSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gwq2y/qllcdgIqxobLgTy3vdQSf2U7pdH63SMZAUUFLHTPOrDSKq2cHdhVu1FTt5Vnems40qbCakYoEmVGozn7XF/yprxvAefIv/5yo+Kg5BJNtyGntmbgXVLjeXwicBuH6uQ1xp22a+8fMev6ycH3mnpHqaVUJ3zm5nCOAuJsk=
Message-ID: <b647ffbd0801200918pe730e07g9f9ef7b811ab254f@mail.gmail.com>
Date: Sun, 20 Jan 2008 18:18:28 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: [patch 1/3] LatencyTOP infrastructure patch
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <b647ffbd0801200847k76b3cf2en5b6b9e169d6aefe4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4790E3A6.7060807@linux.intel.com>
	 <20080118093943.0048d0f7@laptopd505.fenrus.org>
	 <b647ffbd0801200847k76b3cf2en5b6b9e169d6aefe4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2008, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> Hello Arjan,
>
> a few comments on the current locking scheme.

heh... now having read the first message in this series ("[Announce]
Development release 0.1 of the LatencyTOP tool"), I finally see that
"fine-grained locking" is still on your todo list :-)


-- 
Best regards,
Dmitry Adamushko
