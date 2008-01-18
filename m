Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYARDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYARDQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYARDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:16:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:36878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYARDQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:16:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H8ochnV42G0rfyw+uh+Nkq75b/ekex6WUxTHMJub8EC09fi0E5BE0rY49YjFTGgc7i96IPn44tJaYIED1Qqem+bxJQCd/Qn5SpPdHBNyYFjxD00LqAkkF+5CbRChTV3D/oPwu1oXFtb6XuDeNeE4QkSFmYXbnjv1mvpB1gTh9hw=
Message-ID: <fa0147d90801171916u2b96bfa0jbeceef57c9c0f641@mail.gmail.com>
Date: Thu, 17 Jan 2008 19:16:03 -0800
From: Taral <taralx@gmail.com>
To: "Michael Opdenacker" <michael-lists@free-electrons.com>
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c compiling
Cc: "Matt Mackall" <mpm@selenic.com>, "Ingo Molnar" <mingo@elte.hu>,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
In-Reply-To: <200801172315.29976.michael-lists@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <478F8AEC.1080209@free-electrons.com>
	 <1200590031.5332.19.camel@cinder.waste.org>
	 <200801172315.29976.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/08, Michael Opdenacker <michael-lists@free-electrons.com> wrote:
> Another issue would be that we would no longer be able
> to load the speaker driver module from a kernel which
> wasn't originally compiled with support for this module.

Have you looked at pcspeaker.o? As far as I can tell, it does *nothing*.

-- 
Taral <taralx@gmail.com>
"Please let me know if there's any further trouble I can give you."
    -- Unknown
