Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZA1Xjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZA1Xjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZA1XjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:39:22 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:39202 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbZA1XjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FbIF3N1xatVivYRytPuGb5QAmOL8Xo0McsR2spQ29feKtEofIa0A77lH1cNWF0G0nY
         O6fOgBKyTF63oCknbED8OsYhzTWJV2kf1Zu9XBfha39sUNzNg9Ymr0Bzmxkp9TGEqcHQ
         hCIO68tYt0vVGSt2u5hds9IePqvgbnm9Pro0A=
MIME-Version: 1.0
In-Reply-To: <2QN7KFic7LG.A.03.I-QdJB@chimera>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
	 <2QN7KFic7LG.A.03.I-QdJB@chimera>
Date: Thu, 29 Jan 2009 02:39:17 +0300
Message-ID: <a4423d670901281539s958128avcaf4756021125795@mail.gmail.com>
Subject: Re: [Bug #12402] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/20 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12402
> Subject         : 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
> Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> Date            : 2009-01-09 04:41 (11 days old)
> References      : http://thread.gmane.org/gmane.comp.file-systems.xfs.general/27548
> Handled-By      : Christoph Hellwig <hch@infradead.org>
>

Should be closed, thanks.

commit 74e2d06521913443c7e2697037909f5efc200ec5
(Long btree pointers are still 64 bit on disk)
