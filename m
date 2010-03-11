Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0CKPPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:15:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:33678 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab0CKPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hqu3rthHdtT+CSOImyKD14IBuGh+klstITnvvYQlv1wvpw9zAikahDs/1IrhZ7Z7vi
         TKrySQgihyvSpd2ts/eB7/InUDYu3u4Q3MG2JBwXEqCrHYrWYD6e4B6HJ/fsQZ7TR9hp
         UNVh+8WCCcytByJIL23OlaXW2b8aL5T4STn7I=
MIME-Version: 1.0
In-Reply-To: <87aaueopt9.fsf@devron.myhome.or.jp>
References: <87iq93s013.fsf@devron.myhome.or.jp>
	 <1268319614-21252-1-git-send-email-andy.shevchenko@gmail.com>
	 <87aaueopt9.fsf@devron.myhome.or.jp>
Date: Thu, 11 Mar 2010 17:15:12 +0200
Message-ID: <5ec8ebd51003110715y3996e51eof03088395891867b@mail.gmail.com>
Subject: Re: [PATCHv2] fs: fat: use pack_hex_byte() instead of custom one
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 5:12 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> (From 1/4 with previous patch, I guess it's series of patches) Or I
> should take this patch into my tree?
It has only one in common - cleanup. Basically it's a bunch of
independent fixes.
Please, take it in your tree. thank you.

-- 
With Best Regards,
Andy Shevchenko
