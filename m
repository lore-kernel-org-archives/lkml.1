Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbXHDFe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbXHDFe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 01:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXHDFeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 01:34:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:19527 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbXHDFeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 01:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dl3pjSo4UMaptwHf/QoxW8CYiq/1/VWlWjY93pj74TY5+m5wvdllw3zFHSCFJQYyTnLNCd+CmpZGn0c11LwGQjCcXncEMUHsiqCtFvbru/b+4+xM7pk/tLS145PXB0K2O3Wck7bgiHE4XI/0xtn02RVKMsSypiHNYeyr6HzGimI=
Message-ID: <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
Date: Sat, 4 Aug 2007 13:34:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On 8/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> After resume from s2ram or switching to console from X, my console is
> messed up on rc1 and rc2. Is there a fix for this?

This is on IBM X60. i915 chipset. No problem on 2.6.22. If this is a
known problem, than I don't need to bisect all over again.

Thanks,
Jeff.
