Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZEJL2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZEJL2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 07:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZEJL2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 07:28:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:10828 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZEJL2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 07:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FcXwHNkR4cRlHnRUM+xSCqVq76PuWSoK92ta3XvstxfVbKi/+paLursuwaujT7HN+6
         q8en9cBEWe4y3mltIc9x9HUyGnqa51BGrtRzDXOL2kzsS417zPVJH+msyGHvlXHeX6TO
         r9b5L1b1m5GM0zBnMh+hlcBBNKf/XbLo9fzjM=
Message-ID: <4A06BA42.2050107@gmail.com>
Date: Sun, 10 May 2009 20:28:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Subject: Re: [GIT PATCH] block: unify request processing model and implement
 peek/fetch
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> All changes have been compile tested.  libata, ide, hd and ubd_kern
> are verified to work.  Waiting for floppy media to test it.

Floppy verified to work.

Thanks.

-- 
tejun
