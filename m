Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZC1OEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZC1OEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 10:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZC1OEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 10:04:14 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45091 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbZC1OEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=Mgb51wwrrACIVNNciBOcXyGRZkhtncrCANb9Re/4gZSMRJorhh7xb+a+I0KTwxbwPV
         q0tOzVatBxipYPkXwzJ2NfVf5UvlSR8Ytj1JuuyImAQLUDLyHMIuEGG4Af9gnBI3sqAQ
         W/fDIQ7x1MUvnrZL5cGq63fV70UNmR+yJM09E=
Date: Sat, 28 Mar 2009 15:04:05 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc
	cleanups
Message-ID: <20090328140405.GA2741@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, linux-ide@vger.kernel.org
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200903281451.01361.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 02:51:01PM +0100, Bartlomiej Zolnierkiewicz wrote:

[..]

> > Bartlomiej, if you're okay with the changes and Jens acks the patches
> > and pushing the first three patches via pata-2.6, please feel free to
> > include these patches into your tree.
> 
> Everything looks fine to me.  Once I get Jens' ack (block bits)
> and Borislav's one (ATAPI bits) I'll happily merge this patchset.

Yep, I just finished testing the whole series here so you can go ahead
and apply them pending a recast of patch 07/14 you'll hopefully be
receiving soon from Tejun.

-- 
Regards/Gruss,
    Boris.
