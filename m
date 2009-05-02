Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZEBHdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZEBHdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZEBHdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:33:37 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:42812 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZEBHdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vawdf4iNOf2QxAiDAKYdmBqxbxioVvVqkjgQzROR1dInYzG4NMswI4Yn9vSqM0FIbH
         wWriOH1JDM6c/rH+OhKQy1sKuN2Kf2WNQMv/Cm0QqcBb0XnZyOxpR3eNh8PiLoeK163l
         EEeR3N9Pl5F2tZ5POaQvpnIIRSLnqXP6slnsg=
MIME-Version: 1.0
In-Reply-To: <20090501015902.ed8b56d3.akpm@linux-foundation.org>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <20090501015902.ed8b56d3.akpm@linux-foundation.org>
Date: Sat, 2 May 2009 09:33:35 +0200
Message-ID: <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
>
>> This is a repost of DRBD
>
> Is it being used anywhere for anything?  If so, where and what?

One popular application is to run iSCSI and HA software on top of DRBD
in order to build a highly available iSCSI storage target.

Bart.
