Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYI3Qf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYI3Qf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYI3QfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:35:19 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44745 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYI3QfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cjg/KiVy+uNSKh+i1SfbI+Oi6KE//36CUJgBC9Bq3C2nixHuIGI3AFDCmopue/GTw3
         nYh7DpVDFu1A3OtqSwhrifZntqzRUsStEc4WJ+/CJy0PeNXK8tp5qYAWQx3lgcaG8F4Q
         81o5vg19INET3XfhU0vbjsY27jRHmFx6J0sXQ=
Message-ID: <457e13650809300935p22d4be2fuddbcc8a40d5dc8bc@mail.gmail.com>
Date: Tue, 30 Sep 2008 19:35:15 +0300
From: "Oleksandr Natalenko" <pfactum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: REGRESSION: Sound's decreasing when headphones are plugged
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <s5hbpy5hhat.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <457e13650809121314k44ba4978xb1413f856f951bfb@mail.gmail.com>
	 <457e13650809121503o8fea405kce9002495a65953@mail.gmail.com>
	 <s5h7i9g9j7u.wl%tiwai@suse.de>
	 <457e13650809131547y14d989efk1bd31df11dd3dff0@mail.gmail.com>
	 <s5hbpy5hhat.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/30 Takashi Iwai <tiwai@suse.de>:
>
> Thanks.  I put the following simple fix to the next pull request.

Thanks!
