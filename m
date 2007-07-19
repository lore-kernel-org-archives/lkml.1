Return-Path: <linux-kernel-owner+w=401wt.eu-S965384AbXGSRIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384AbXGSRIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964945AbXGSRHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:07:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:8167 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940004AbXGSRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qtTUn34PB0VmEwB1PBfsAR8ood1G7spiTbhOOYA5ZFvMixyq/mgbJ1WfW4amWrcHQFbktXrorIy+USuAdLNZ5T+TF9INWjGfWYbwDmDDAHW5x08KHZU/u1EawNXBBsKDnBYwX6vyMImnXPqKmqI73cWVh/7oeRxhvkyd2UflFzo=
Message-ID: <a781481a0707191007q241f5f5bh6c029da56090d8b3@mail.gmail.com>
Date: Thu, 19 Jul 2007 22:37:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/2] 2.6.22-git: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Theodore Tso" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       "Mingming Cao" <cmm@us.ibm.com>, "Doug Chapman" <doug.chapman@hp.com>,
       "Vasily Tarasov" <vtaras@openvz.org>, linux-ide@vger.kernel.org,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Kumar Gala" <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       "Christoph Lameter" <clameter@sgi.com>, "Andi Kleen" <ak@suse.de>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jean Delvare" <khali@linux-fr.org>, "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <469F92AF.10405@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F9125.8040502@googlemail.com> <469F92AF.10405@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject         : ext4 build warnings
> References      : http://lkml.org/lkml/2007/7/18/420
> Last known good : ?
> Submitter       : Jeff Garzik <jeff@garzik.org>
> Caused-By       : ?
> Handled-By      : Mingming Cao <cmm@us.ibm.com>
> Status          : unknown

Mingming Cao fixed this:

http://lkml.org/lkml/2007/7/18/564

Dunno if it's in latest git
