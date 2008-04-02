Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYDBE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYDBE1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYDBE1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:27:09 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:51599 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYDBE1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:27:07 -0400
Message-ID: <fa686aa40804012127n6db5c8a0sbe625b964c75b2d2@mail.gmail.com>
Date: Tue, 1 Apr 2008 22:27:04 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: Please pull powerpc.git merge branch
Cc: "Bartlomiej Sieka" <tur@semihalf.com>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <18418.49494.457893.866627@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18412.58902.189124.391104@cargo.ozlabs.ibm.com>
	 <47ED6BE5.9060807@semihalf.com>
	 <18418.49494.457893.866627@cargo.ozlabs.ibm.com>
X-Google-Sender-Auth: 798e5b72f17d3498
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2008 at 5:12 PM, Paul Mackerras <paulus@samba.org> wrote:
> Bartlomiej Sieka writes:
>
>  > What about http://patchwork.ozlabs.org/linuxppc/patch?id=17525 ? I don't
>  > see it in the merge branch of your repository, and it would be nice to
>  > get it upstream as it fixes boot problems on some MPC5200-based boards.
>
>  It needs a proper stand-alone commit message and an acked-by from
>  Grant.  The commit message should explain why you are making the
>  changes you are making rather than just saying "the bulk of this patch
>  is taken from http://...".

Total Ack.  I just missed it when it was sent.  But Paul is right, it
needs a real commit message.  Feel free to add my Acked-by: line when
you resend.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
