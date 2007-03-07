Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXCGCC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXCGCC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXCGCC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:02:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:17000 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161206AbXCGCCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=boz1x5Fbj3PAMeOk2WoP2PM6a8bdyZ+1x9xztt7kkpJgZyrFJ6JKanzD42lHZdOn7xFDdsn4gEV1O+FncXO3nDvgzdbklQSoPtjlDbXklgTvnHrr0r9ZZHVdbW1KsdZfT59xIz7i5GGaVQeXAULVgJjQdqT3rIg47aCYE+9rhbo=
Message-ID: <75b66ecd0703061802g29246g3a6c2c9123d891b3@mail.gmail.com>
Date: Tue, 6 Mar 2007 21:02:52 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: Mockern@yandex.ru
Subject: Re: Problem: how to make kernel thread more faster?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45ED1AED.000003.06978@webmail13.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED1AED.000003.06978@webmail13.yandex.ru>
X-Google-Sender-Auth: c62de680ab746c1b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Mockern <Mockern@yandex.ru> wrote:
> hi,
>
> Is there a way how to make kernel thread more faster?
>
> I put some of my code to the kthread, but I noticed that kthread sends data more slow
> than original driver without kthread.

Please post a link to your driver source code.

Lee
