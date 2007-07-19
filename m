Return-Path: <linux-kernel-owner+w=401wt.eu-S940205AbXGSQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940205AbXGSQv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762719AbXGSQvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:51:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:43587 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939834AbXGSQvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nIEboVR6xc0hDq1h/cnU3f8QB4YjtNYmgUOFd20p2t+U7MYbPO+qQ8Sf+/yNuK5UP+Uh2HtFt/M43JAdCkEbEVLOZ/WyPby9xkipurQs5nE8lQNHfuXbAwglVhmNb8qj+YimoWQadtTLIlZxfYwarb293Dkp8D5NgetAyV6iQtM=
Message-ID: <6bffcb0e0707190951j1f350683l62415b9ce24f0e8a@mail.gmail.com>
Date: Thu, 19 Jul 2007 18:51:44 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [2/2] 2.6.22-git: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jean Delvare" <khali@linux-fr.org>, "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <20070719162625.GA16505@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F9125.8040502@googlemail.com> <469F92AF.10405@googlemail.com>
	 <20070719162625.GA16505@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jul 19, 2007 at 06:34:55PM +0200, Michal Piotrowski wrote:
> > SYSFS
> >
> > Subject         : sysfs root link count broken in 2.6.22-git5
> > References      : http://lkml.org/lkml/2007/7/15/62
> > Last known good : ?
> > Submitter       : Jean Delvare <khali@linux-fr.org>
> > Caused-By       : ?
> > Handled-By      : Tejun Heo <htejun@gmail.com>
> > Status          : unknown
>
> This is now fixed in Linus's tree with a patch from Tejun.

Thanks for the information
commit e080e436f605877e47e4950f5386ed843badbb1b

>
> thanks,
>
> greg k-h
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
