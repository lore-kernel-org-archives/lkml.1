Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbYLUG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbYLUG0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 01:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYLUG0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 01:26:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:43002 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYLUG0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 01:26:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NgI3qSJNlQAIqh2lljLcFeDVtreuxQrjfkROXluXoFrC0lvhbVQDPOBFQvEeOFYBmH
         QLNLeahGgObeSlC+Wxa3nSmhZWtOObJLi2GM4nLMSRscqT9j3q7RZQXj+QdJ62EmegVY
         ceK3x4GL5EKmC/tbrJ32+/tCJHUFxfuwxETCk=
Message-ID: <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>
Date: Sun, 21 Dec 2008 01:26:00 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20081220221253.e09b1b1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
	 <20081220221253.e09b1b1f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 1:12 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> You're sure that 2.6.28-rc8 was OK?

Nope - not sure about 28-rc8. I meant to say some previous 28-rc's
that I tested worked fine - can't recall which ones. it is likely I
missed testing .28-rc8.

>
> 2.6.28-rc9 had only a small number of changes.  Nothing I can see in
> input or HID.  A few USB changes, but pretty specific ones -
> unusual_devs entries and such.
>
> Maybe your mouse has died?  Did you retest with an older kernel?
>
I did - rebooting into 2.6.27 (original distro kernel) makes it work again.

Thanks

Parag
