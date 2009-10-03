Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZJCOHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZJCOHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZJCOHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:07:11 -0400
Received: from mail-yw0-f142.google.com ([209.85.211.142]:39454 "EHLO
	mail-yw0-f142.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbZJCOHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:07:10 -0400
X-Greylist: delayed 2692 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2009 10:07:10 EDT
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 06:22:21 -0700 (PDT)
In-Reply-To: <dqWVs-3hD-15@gated-at.bofh.it>
X-IP: 98.217.44.68
References: <dqBnV-3pF-5@gated-at.bofh.it> <dqWVs-3hD-15@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.14) 
	Gecko/2009082707 Firefox/3.0.14,gzip(gfe),gzip(gfe)
Message-ID: <b4c460e2-0e83-415a-b3ef-4b95188e5de4@o21g2000vbl.googlegroups.com>
Subject: Re: Add hpsa driver for HP Smart Array controllers.
From: stevec <stephenmcameron@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 2, 4:30 pm, Rolf Eike Beer <eike-ker...@sf-tec.de> wrote:
> Stephen M. Cameron wrote:
> > +static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
> > +  "UNKNOWN"
> > +};
> > +#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0]) - 1)
>
> (ARRAY_SIZE(raid_label) - 1)
>
>
[...]

Thanks for the feedback.

-- steve

