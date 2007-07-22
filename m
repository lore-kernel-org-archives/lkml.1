Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbXGVJFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbXGVJFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761272AbXGVJFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:05:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:9766 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761120AbXGVJFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XLUamsXp3l1pOJ41EMQCrSK5LsqnxCQJF+cx3avyE08rxwvkTnfPYhyd+haahR18NBXX7tQtmDJ/60ea+if6Kw1XuUVol3AK39R2AcRHB6TM1ZvBEGPsU8x2Wj9dVkwbSJHvhhC+Vt0lRjJXWQbZ2S1L7LIxBtMEcIGYQRKDpN4=
Message-ID: <84144f020707220205y57370351ge478537c649800b2@mail.gmail.com>
Date: Sun, 22 Jul 2007 12:05:05 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Cc: "Andi Kleen" <andi@firstfloor.org>, "Jens Axboe" <axboe@kernel.dk>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
In-Reply-To: <20070722085217.GA27849@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <p73hcnxuxji.fsf@bingen.suse.de>
	 <20070722060925.GD18326@mail.linbit.com>
	 <20070722085217.GA27849@uranus.ravnborg.org>
X-Google-Sender-Auth: 6cd1ee1da73f78e4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 7/22/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> So essentially smaller pieces that can be revied but when ready for inclusion
> it should go in as _one_ commit to avoid breaking bisect.

Or alternatively, put all Kconfig and Makefile changes in the last patch.
