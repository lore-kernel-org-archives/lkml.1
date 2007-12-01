Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbXLAQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbXLAQwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 11:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXLAQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 11:52:07 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3990 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbXLAQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 11:52:07 -0500
Message-ID: <475190FF.6070801@xs4all.nl>
Date: Sat, 01 Dec 2007 17:51:11 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       folkert@vanheusden.com
Subject: Re: enable dual rng on VIA C7
References: <47374EA4.1060009@xs4all.nl>	<20071125233949.f64b2ecd.akpm@linux-foundation.org>	<474AFC2F.1040309@xs4all.nl>	<20071126185843.GD15764@redhat.com>	<474C40FA.1070501@xs4all.nl>	<20071127185053.GA30057@redhat.com> <20071127125109.a2ef96f2.akpm@linux-foundation.org>
In-Reply-To: <20071127125109.a2ef96f2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Andrew, want to throw that in the -mm pile for a while?
> 
> Did that, renamed to "via-rng: enable secondary noise source on CPUs where
> it is present".
> 
> Has anyone tested it?

I hope so; I did not yet get that far since the patche does not compile
on 2.6.23.8. I was assured by Dave that the patch should work on 2.6.24
(and mm-tree).
