Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbYAYTD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbYAYTD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbYAYTDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:03:47 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3415 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbYAYTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:03:46 -0500
Message-ID: <479A326E.7020302@xs4all.nl>
Date: Fri, 25 Jan 2008 20:03:10 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, mb@bu3sch.de,
       folkert@vanheusden.com
Subject: Re: enable dual rng on VIA C7
References: <47374EA4.1060009@xs4all.nl>	<20071125233949.f64b2ecd.akpm@linux-foundation.org>	<474AFC2F.1040309@xs4all.nl>	<20071126185843.GD15764@redhat.com>	<474C40FA.1070501@xs4all.nl>	<20071127185053.GA30057@redhat.com> <20071127125109.a2ef96f2.akpm@linux-foundation.org>
In-Reply-To: <20071127125109.a2ef96f2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 27 Nov 2007 13:50:53 -0500
> Dave Jones <davej@redhat.com> wrote:
> 
>> On Tue, Nov 27, 2007 at 05:08:26PM +0100, Udo van den Heuvel wrote:
(...)
>>  > Yes, I think that's a big step in the right direction!
(...)
>> Andrew, want to throw that in the -mm pile for a while?
>>
> 
> Did that, renamed to "via-rng: enable secondary noise source on CPUs where
> it is present".
> 
> Has anyone tested it?

Works for me.
Did anyone else have a look?
