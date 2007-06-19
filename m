Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbXFSJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbXFSJkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXFSJkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:40:42 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:44919 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbXFSJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:40:41 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: "David Brown" <dmlb2000@gmail.com>
Cc: "Goswin von Brederlow" <brederlo@informatik.uni-tuebingen.de>,
       fuse-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [fuse-devel] FS block count, size and seek offset?
References: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
	<87645lr69g.fsf@informatik.uni-tuebingen.de>
	<9c21eeae0706180744v5ad9a1a3s10da42c6d6f61637@mail.gmail.com>
Date: Tue, 19 Jun 2007 11:40:35 +0200
In-Reply-To: <9c21eeae0706180744v5ad9a1a3s10da42c6d6f61637@mail.gmail.com>
	(David Brown's message of "Mon, 18 Jun 2007 07:44:56 -0700")
Message-ID: <87lkegqo30.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"David Brown" <dmlb2000@gmail.com> writes:

>> Why don't you use the existing fuse-unionfs?
>
> I thought about doing this but it would need to be modified somehow
> and even then my users would look to me to fix issues and I don't like
> trying to find hard bugs in other peoples code.
>
> Also, there's a lot of functionality that funionfs has but I don't
> need and the extra code would get in the way attempting to modify or
> debug issues.
>
> What I want is fairly specific and I've not seen anything out there to do it.
>
> Thanks,
> - David Brown

You can still read their code to see how they solved problems you
have.

MfG
        Goswin
