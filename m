Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbXHDFNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbXHDFNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 01:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXHDFNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 01:13:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:47465 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbXHDFNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 01:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=udDvMJeNNAXkamt8HO6tzrKe6w1ou1ehS8C/OZF4CRpIT6FtrMcXRGyYiE/NaeJF/YpoK2tr9Fxb0TvJgks6Gm0ztDH7lR8J/APaqaOiG7IN75SJPa5FWEQ008weQoQiGoQhi2z4dxkzuO0Iev5XkRif/QFs014OIA+UdcsIBrk=
Message-ID: <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
Date: Sat, 4 Aug 2007 13:13:21 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> A lot of the changes are small, and a lot of them really are fixes, but
> there's a MIPS merge in there too, and some absolutely _huge_ diffs due to
> some drivers undergoing Lindent cleanups (28 _thousand_ lines changes in
> advansys.c, and the PNP files got Lindented too, although those weren't
> nearly as big).

After resume from s2ram or switching to console from X, my console is
messed up on rc1 and rc2. Is there a fix for this?

Thanks,
Jeff.
