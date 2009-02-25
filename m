Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZBYID1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZBYID1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZBYIDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:03:17 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:19372 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbZBYIDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:03:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JOuzW1LKsdI3HOo01m+6nKI9XLkF/y7Flgr9caB0R+imby7J4vmqSRJfEIYV+SOoU1
         Rznt/YioIIoauu5ltX8MWbbu3pEl0ByE/hnAJpmVlzfWrAG75mShToGWDBX3iB+S3XYZ
         L089agKHYgF4FuRmGu0whljdtSZvJcLofLv04=
MIME-Version: 1.0
In-Reply-To: <20090225044730.GA9106@july>
References: <20090225044730.GA9106@july>
Date: Wed, 25 Feb 2009 13:33:14 +0530
Message-ID: <5d5443650902250003g7df7093bn59e0fc052ffb6ed@mail.gmail.com>
Subject: Re: [PATCH] Input notifier support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Wed, Feb 25, 2009 at 10:17 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.
>

I am not able to understand this.

> So add input notifier and then use it at other frameworks such as led.
> Of course, other input device can use this one.

If it is just LED, then you may write some led-input-trigger?

>
> Any commnets are welcome.

Could you please show example driver too, in-order to explain its usage. Thanks.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
