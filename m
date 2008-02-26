Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYBZFjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYBZFjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYBZFj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:39:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:32885 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYBZFjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uTtIqGEhyee6Vvz7HL11iYnPXYcYELWDt1/BGD2KhSGcdh158bw4TI9GcBOzxDEUqyz7R3R41GA2BfdnZd4EIrNvyXIpPM4w/uNrOiFODiHpQw1t4nB4sjWycfFLpbqmJdfk/HR7Vjr5GcWN+sDkZC1ed5nMZluwk4QmixHjmMA=
Message-ID: <93564eb70802252139t7c184c31l733ac0bce2a9fc97@mail.gmail.com>
Date: Tue, 26 Feb 2008 14:39:23 +0900
From: "Samuel Masham" <samuel.masham@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: Linux 2.6.24.3
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080226010024.GA26889@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080226010024.GA26889@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:00 AM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> We (the -stable team) are announcing the release of the 2.6.24.3
>  kernel.
>

Hi Greg, Stable people :)

Can you confirm you have the mips irq probe crash fix in your queue
for the next stable release

See:

http://lkml.org/lkml/2008/2/24/255

Is there anymore I should do to help the process along?

Thanks

Samuel
