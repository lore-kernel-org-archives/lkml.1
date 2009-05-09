Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZEIR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZEIR14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZEIR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:27:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:27799 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZEIR1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JU2zL+Xu0FQU99Hzl2M28hXsJVRkMVxW4aCwP0s68WnfAcYahZroA6mNhMAbVlvLdW
         eeN4KsCv3HRekYA5OtxUPYdFLGvLZ6vw0esIxXlY4sH8wNQPpTws7RKPm21jXJXB7cm4
         TOjEvGiSSmXiP5kpGks1dgumqy6H1ybrGc1EY=
MIME-Version: 1.0
In-Reply-To: <4A04E5EA.7000103@samsung.com>
References: <4A04E5EA.7000103@samsung.com>
Date: Sat, 9 May 2009 22:57:47 +0530
Message-ID: <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
From: Trilok Soni <soni.trilok@gmail.com>
To: Kim Kyuwon <q1.kim@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Sat, May 9, 2009 at 7:39 AM, Kim Kyuwon <q1.kim@samsung.com> wrote:
> The Maxim MAX7359 is a I2C interfaced key switch controller which provides
> microprocessors with management of up to 64 key switches.
> This patch adds support for the MAX7359 key switch controller.
>
> Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>


Thanks for implementing review comments. Please add

Reviewed-by: Trilok Soni <soni.trilok@gmail.com>

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
