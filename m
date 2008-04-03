Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbYDCPmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbYDCPmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYDCPml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:42:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:13551 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbYDCPmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:42:40 -0400
Message-ID: <9ea470500804030842ne89877dg840c960eb44f0219@mail.gmail.com>
Date: Thu, 3 Apr 2008 17:42:32 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Proposed patch for IDE missing commands
Cc: "Frans Pop" <elendil@planet.nl>, x.guimard@free.fr,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
In-Reply-To: <47F4F6D7.4050908@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <47F47324.80108@free.fr>
	 <9ea470500804030228p3077456ai4a756aa46116aa4c@mail.gmail.com>
	 <200804031220.07380.elendil@planet.nl>
	 <47F4F6D7.4050908@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 5:25 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Frans Pop wrote:
>  > Boris Petkov wrote:
>  >> Please, rebase/redo your patch against latest -rc kernel (in this case
>  >> 2.6.25-rc8) und run it through scripts/checkpatch.pl in order to adjust it
>  >> to the kernel coding style. See Documentation/CodingStyle for details.
>
>  Why don't linux kernel insiders help first-time contributors here a bit
>  and simply repost the patch with style fix-up?  That would be a matter
>  of 10 minutes or so and a more valuable contribution than a mere
>  RTFCodingStyle.

Well, it'll probably take the same time to run checkpatch.pl on it and
simply do what the
tool suggests wrt to style - after all this can't be more complex than
writing kernel code
in itself, now can it? What is more, my suggestion was also to _redo_
the patch against a more
recent kernel version since ide-disk has changed since then and, even
disregarding code
style issues, the patch is inapplicable as such (e.g. deleted
functions) Finally, despite all
that who's-doing-what soul searching, redoing patches has a great
didactical value which
all of us have experienced time and again :).


-- 
Regards/Gruﬂ,
Boris
