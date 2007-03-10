Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXCJWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXCJWMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXCJWMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:12:00 -0500
Received: from 1wt.eu ([62.212.114.60]:1114 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbXCJWL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:11:59 -0500
Date: Sat, 10 Mar 2007 23:11:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: michael chang <thenewme91@gmail.com>
Cc: Stephen Clark <Stephen.Clark@seclark.us>, ck list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: RSDL v0.28 for 2.6.20
Message-ID: <20070310221150.GA6274@1wt.eu>
References: <200703101845.59497.kernel@kolivas.org> <45F2F45F.6000403@seclark.us> <20070310191118.GL943@1wt.eu> <b14e81f00703101356s248bd914m91c26e2d22e507d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b14e81f00703101356s248bd914m91c26e2d22e507d4@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:56:57PM -0500, michael chang wrote:
> On 3/10/07, Willy Tarreau <w@1wt.eu> wrote:
> >BTW, Con, I think that you should base your work on 2.6.20.[23] and not
> >2.6.20 next time, due to this conflict. It will get wider adoption.
          ^^^^^^^^^^

> Maybe I'm naive, but I find this hard to understand -- 2.6.20.2 didn't
> exist when Con published his patch. (Con published it ~12 hours before
> the release of 2.6.20.2, from what I can tell.) How can he base his
> work on something that didn't yet exist? (And it applied cleanly to
> 2.6.20.1, the latest when he published it.)

You see the words I have underlined ? "next time". I know for sure he
published it before 2.6.20.2, but now that it is out, I suggested that
Con rebases his work on this version for new releases.

Regards,
Willy

