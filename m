Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZJASu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZJASu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZJASuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:50:25 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37112 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZJASuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=WYBf2Nynp7IypnyM0w215rTTIL94snvIVlpvr9pfcVsqWk0KpLiFOzFVzlgfLVTvI/
         QYmqsikcwGvhmHbhjo0eMaVykzDpb2Q3fR4/aZjaA1gMIc6BEyB9tJSZVLaxj3yJbzb6
         G187S3WrHFoVMaVJinmkQDF6uXYCHvJmNOcTE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
Date: Thu, 1 Oct 2009 20:52:16 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-dirty; KDE/4.3.1; i686; ; )
Cc: elendil@planet.nl, manty@manty.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200910011125.40081.bzolnier@gmail.com> <200910012021.24260.bzolnier@gmail.com> <20091001.113418.139794332.davem@davemloft.net>
In-Reply-To: <20091001.113418.139794332.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200910012052.16465.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 October 2009 20:34:18 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 1 Oct 2009 20:21:24 +0200
> 
> > - for the last three months you haven't debugged/fixed a single IDE issue
> >   and you keep dodging every single bug-report 
> 
> I mostly do the same with networking, and I'm the maintainer there
> too. :-)
> 
> And regardless of my workload, all reasonable patches and bug fixes
> submitted for IDE flowed freely during this time, or were given
> a review NACK.
> 
> I depend upon subsystem contributors to fix the bugs, that's how this
> works.  I merely mediate, review patches, apply patches, and chip in
> with some work of my own from time to time as the situation and my
> workload dictate.

IIRC you were not very content with exactly this style of my management
of IDE some years ago..  However I'm really glad that it works for you
so well in the networking, and now in IDE too! :)
