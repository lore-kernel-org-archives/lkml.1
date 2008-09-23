Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYIWI7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYIWI7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYIWI7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:59:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:5042 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYIWI7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZfUNGcjd4N0/cPo4TjChyBZ7e/Yd5KNPFB827T0D6W2woscJhRNNb7dEhKd1eQAePS
         yb5peflM7Ofwxm7KegW2rLUteJvGurYtn8isfKhOAYAIIAbUlK7joP/4q4DRb4YFcthQ
         0xu2F64mom+AQGG2nTbCjMXjlKi3drqFs+ggQ=
Message-ID: <ed7dcf450809230159o16ed28ffweacf46aed08cf345@mail.gmail.com>
Date: Tue, 23 Sep 2008 10:59:06 +0200
From: "=?ISO-8859-1?Q?S=F8ren_Hauberg?=" <hauberg@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <200809231055.35919.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com>
	 <200809231055.35919.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/23 Oliver Neukum <oliver@neukum.org>:
> Am Dienstag 23 September 2008 10:42:56 schrieb Søren Hauberg:
>> calibration parameters in the kernel. That way, we can also get usable
>> touchscreens without X, without having to write special purpose
>
>
> Is that a realistic use?

Perhaps for people using the framebuffer to create GUIs? To me, it's
not important, but I guess it's a positive side-effect.

Søren
