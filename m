Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbZFPU4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbZFPU4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbZFPU4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:56:30 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:58861 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633AbZFPU43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:56:29 -0400
X-Greylist: delayed 151973 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 16:56:29 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S/Qa1aAMlCBHUPAMNmaTqMKTB1cMjvu1PNtXEMLKlBYr4sna6QYoaj4SH7rAskgN3i
         4Z5FDzBjvx0j7048ecx1sOtfUj7t+r7KDIrULDDI7E3HxsRtSp3FSU0w+p+ArAhfe0Yj
         Gy6QUPFW3sQCY3IsgjuXdXID3g61wSdJ3f0rY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906161351130.16802@localhost.localdomain>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>
	 <20090615022235.GA12905@kroah.com>
	 <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
	 <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com>
	 <alpine.LFD.2.01.0906161119500.3282@localhost.localdomain>
	 <21d7e9970906161345q6e826d18q3a197643e370156c@mail.gmail.com>
	 <alpine.LFD.2.01.0906161351130.16802@localhost.localdomain>
Date: Wed, 17 Jun 2009 06:56:31 +1000
Message-ID: <21d7e9970906161356y75702185gff0500571fff1e47@mail.gmail.com>
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ryan Hope <rmh3093@gmail.com>, Greg KH <greg@kroah.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 6:52 AM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 17 Jun 2009, Dave Airlie wrote:
>>
>> Linus can you pull this tree?
>
> I hate pulling trees when I know there are _known_ bugs.
>
> Even during the merge window. The rest of the -rc series is for fixing up
> bugs, yes, but not bugs that were introduced on purpose.
>

It only happens if the user enable staging drivers, and I suspect staging
has much worse bugs, but okay I'll put the initcall fix into the tree
and send you
another pull request.

Dave.
>                Linus
>
