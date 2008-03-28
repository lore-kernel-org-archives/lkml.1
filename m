Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYC1Dbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYC1Dbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYC1Dbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:31:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:55773 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYC1Dbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C0FfBRkusBTsVSr7hpNvHMMAdJsr8QUAF+gwwMA4rnm9csHsca9YZ3BoVS4vpl/dO2lsC7Ad69k8FsQkqPvzVIRSeA0pAKhJqw/aJpAo1lNLo+xytkVWaVtzln+Zl3jMf9dWa4zKUD2deqwLCebA8jR9+6r1FAsOOIAzkqlOMWs=
Message-ID: <86802c440803272031o2d3c1d3aw4f03e60883a8716e@mail.gmail.com>
Date: Thu, 27 Mar 2008 20:31:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pawel Staszewski" <pstaszewski@artcom.pl>,
       "Christoph Lameter" <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803272353.51901.rjw@sisk.pl>
	 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 7:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
>  >
...
>
>  > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=9962
>  > Subject               : mount: could not find filesystem
>  > Submitter     : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>  > Date          : 2008-02-12 14:34 (45 days old)
>  > References    : http://lkml.org/lkml/2008/2/12/91
>  > Handled-By    : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>  >                 Yinghai Lu <yhlu.kernel@gmail.com>
>
>  Needs more info. The original oops that opened it is fixed, but..
>
Kamalesh,
can you check that?

YH
