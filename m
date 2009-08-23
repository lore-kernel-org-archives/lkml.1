Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbZHWJL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbZHWJL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZHWJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:11:28 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60780 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZHWJL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=FYDRNftP0RePQORjWiPI0DytPo2z2QsBW+Vbr4KVltuPqBkMsYFkvu8cf7I5UYcUv1
         0WZzlpp6wTIF5jKCKJrJxiWtnxL2EZBqCxDpQow/IiIiF9UbTrOLk+jrOTk6z0n8qe4E
         n0sH0o/ujMMO7uG++YfVzEJISAOKLZfAj9ZSM=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Sun, 23 Aug 2009 11:11:26 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30.5r4; KDE/4.3.0; x86_64; ; )
References: <200908211814.56800.volkerarmin@googlemail.com> <200908222126.31390.volkerarmin@googlemail.com> <86802c440908222322s44957498s72a76940f89271cf@mail.gmail.com>
In-Reply-To: <86802c440908222322s44957498s72a76940f89271cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908231111.26414.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag 23 August 2009, Yinghai Lu wrote:
> On Sat, Aug 22, 2009 at 12:26 PM, Volker Armin
>
> Hemmann<volkerarmin@googlemail.com> wrote:
> > when I went from 4gb to 6gb I had a performance degradation. Since the
> > 8gb are faster and the new cpu is faster, I don't see degradation. But I
> > wonder how much better performance could be with 'correct' mtrr.
>
> that is weird. with 4g should have mem hole remapping.
>
> do you still have /proc/mtrr for 6g setup?
>
> YH

I have it here:
http://marc.info/?l=linux-kernel&m=124336823415460&w=2

Glück Auf,
Volker
