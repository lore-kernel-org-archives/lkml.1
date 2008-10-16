Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYJPGe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYJPGe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYJPGeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:34:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:4185 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJPGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s6MotG4J5MydlDyaHWT48HtdmA61RFjGa1ZurIi3UY5p+tWShTALaeSkaKyyDrE1H4
         zhr/vhTtUyphAzQYRQWN25lVJqw42VN5lqMq0WFFMlF4zyKjK1vj16iX4fyoHqs9rY8k
         9jaV8muyQQiwDT1cDdNuXHjtanZPHDcyWb7rU=
Message-ID: <a8e1da0810152334x6c596f88i1fd74548dc166f3a@mail.gmail.com>
Date: Thu, 16 Oct 2008 14:34:07 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [BUG] hang with ath5k
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <48F6133D.1070508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
	 <48F6133D.1070508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 11:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/14/2008 10:42 AM, Dave Young wrote:
>> 1) run wpa_supplicant
>> 2) ctrl + C
>> 3) goto 1)
>
> It doesn't happen here. How many iterations in average you need to reproduce this?
>

About 15 times for me,
BTW, wpa_gui running while testing

-- 
Regards
dave
