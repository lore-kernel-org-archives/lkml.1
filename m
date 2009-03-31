Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZCaHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZCaHtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZCaHtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:49:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:54218 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZCaHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=JnVLtgqN3f575vFl7zPhPxg0ZCdvdFDytvnDocD5OL6ZvMhwHjckMDvG/CmBBvmL62
         HPxVJY1smm7pwIj7kY+tL3JxMEKGIeno5wEdip6aVY1rEQNtZDjKPzilVFhRqJqrhPsf
         5V2F/5qb/QhH6D4dk8551Lp194CduohXfHhIw=
Date: Tue, 31 Mar 2009 09:48:51 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [RFC PATCHSET pata-2.6] ide: clean up ide-tape
Message-ID: <20090331074851.GA9347@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
	linux-ide@vger.kernel.org
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:17:43PM +0900, Tejun Heo wrote:
> Hi, Bartlomiej, Jens.
> 
> This RFC patchset cleans up ide-tape.  Note that the patchset
> currently is only compile tested, so it's likely to be broken, so the
> RFC status.  Albert Lee is sending me some IDE tape drives, so I'll
> test these patches as soon as I receive them and repost with whatever
> necessary fixes.

By the way,

we may have another potential tester for ide-tape if we ask him nicely
enough :)

See http://bugzilla.kernel.org/show_bug.cgi?id=12874.

-- 
Regards/Gruss,
    Boris.
