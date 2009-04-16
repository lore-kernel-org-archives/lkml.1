Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZDPHHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZDPHHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDPHGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:06:52 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52650 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZDPHGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qPnv36YOPZzTWotCIe2Y+unKl4AONJty6xb8AvjsaNCJfr1poNBOIqxtmLMvgburg6
         mAHy/YLnmyBqDRg/2AQgtdyZqv0jGcBTZqbGJlJM4buS17JSUn9FbDICvk0zATYQjhU2
         Nnk9P2J517+avhcL5yYrotOC0TAOe821FmacQ=
MIME-Version: 1.0
In-Reply-To: <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-4-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-5-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
Date: Thu, 16 Apr 2009 09:06:49 +0200
Message-ID: <e2e108260904160006g359b11aj2714a3df2dfe7bdb@mail.gmail.com>
Subject: Re: [PATCH 05/14] DRBD: request
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> + * See also documentation/drbd-request-state-overview.dot
> + *  (dot -Tps2 documentation/drbd-request-state-overview.dot | display -)

Hello Philipp,

Where can the file drbd-request-state-overview.dot be found ? It's
neither included in this patch series nor in drbd-8.3.1.tar.gz.

As far as I know documentation for new kernel components should be
included in the kernel patch itself as a new file under the
Documentation directory.

Bart.
