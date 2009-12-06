Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZLFHxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZLFHxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZLFHw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:52:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZLFHw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:52:58 -0500
Date: Sun, 6 Dec 2009 08:43:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091206074306.GA1751@ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz> <1260054737.23633.35.camel@desktop> <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-12-05 16:38:31, Brian Swetland wrote:
>    On Sat, Dec 5, 2009 at 3:12 PM, Daniel Walker <dwalker@codeaurora.org>
>    wrote:
> 
>      https://www.codeaurora.org/gitweb/quic/kernel/?p=dwalker/linux-msm.git;a=shortlog;h=refs/heads/testing
> 
>      It's been in Linux-next for maybe two weeks .. I've been trying to
>      decide if I should submit it for 2.6.33. I'm going to be adding boat
>      loads of additional msm code and doing a fairly large merge for
>      2.6.34 .. So your code would get better testing if we wait for that.
> 
>      However, If you really want it in 2.6.33 I'll try to accommodate you.
> 
>    Arve's about to take our common and msm trees and rebase them over the
>    .32, which may be useful for reference -- at least as a snapshot of a
>    fully functional set of patches that android donut and eclair run on, on
>    production hardware.A  We'll make that available as soon as we have
>    something that's bootable.

Looking forward :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
