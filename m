Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbXIWSIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbXIWSIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbXIWSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:08:29 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:18254 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbXIWSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZTsAafHtsO2lph+7EAJJjCdYVmIgYuk1Oj5LY9Vo9dCq8LvdOY44xtl1ElTjae3aoLJbNbVjiMmXoHJbpdzRWf5LMDOKuwFliD9h1PClRcrmxu4eCc5Vk2DdyLrtuPU3+8titpQlID9H9niE1xyz0ZQ1abHMmNGbeJGMaHrKqe0=
Message-ID: <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>
Date: Sun, 23 Sep 2007 11:08:27 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: Urgent bugzilla mainteinance needed
Cc: linux-kernel@vger.kernel.org, "David Ames" <david@linux-foundation.org>,
       "Jon Tollefson" <kniht@linux.vnet.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>
In-Reply-To: <20070923195821.cab02f42.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070923195821.cab02f42.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, Diego Calleja <diegocg@gmail.com> wrote:
> Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3710
>
> bugzilla tries to send a mail to the reporter, it fails ("unknown user account"),
> but the error failure is appended as a bugzilla comment. Then bugzilla tries to
> send that comment to everyone involved in the bug, including the reporter,
> so it fails again.....Houston, we've a endless loop.
>
> There're 540 comments in that bug report already, and the bugme-daemon
> mail list is being spammed....

I just sent emails to those who maintain bugzilla software and systems
that run it, hope someone will be online soon to help alleviate
this...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
