Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbYJJTIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbYJJTIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761710AbYJJTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:07:50 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38326 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652AbYJJTHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Kd37/qlDM/YiIkGIoFruO/VyJ153Yc60ArgVmOJYamUszfGUB3+BfWonq1Bltn1J3C
         YF3HiHc3WZHemvMQasZirVGxSQfa1UsJF0mdMB20mR2oZMHnbSdzZ0nDYaVIkyHAIVvU
         9tZSrVqqLVe6o7s9w/XGuKOGb4STraxTyj6eo=
Message-ID: <43e72e890810101207h767353bem3a080aab27b7eb09@mail.gmail.com>
Date: Fri, 10 Oct 2008 12:07:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Cc: jirislaby@gmail.com, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       jmalinen@atheros.com
In-Reply-To: <20081010.120050.161276431.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
	 <20081010.115318.85254002.davem@davemloft.net>
	 <43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com>
	 <20081010.120050.161276431.davem@davemloft.net>
X-Google-Sender-Auth: 13d58386b9f75983
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 12:00 PM, David Miller <davem@davemloft.net> wrote:
> From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
> Date: Fri, 10 Oct 2008 12:00:17 -0700
>
>> Agreed, patches welcomed.
>
> Translation: "Fix it yourself if you care so much." :-/

Not really, I want to fix it, just want to fix aggregation too. OK
fine, I'll send a patch now.

  Luis
