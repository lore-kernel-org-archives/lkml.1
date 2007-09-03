Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbXICILB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbXICILB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXICIKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:10:45 -0400
Received: from rune.sasl.smtp.pobox.com ([208.210.124.37]:47045 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXICIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:10:43 -0400
From: Junio C Hamano <gitster@pobox.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sean <seanlkml@sympatico.ca>, David Kastrup <dak@gnu.org>,
       git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>
	<46DA5F33.2020005@zytor.com> <85odgltrtj.fsf@lola.goethe.zz>
	<46DA88EF.7080103@zytor.com>
	<20070902133803.1b46f599.seanlkml@sympatico.ca>
	<7v4picpvgq.fsf@gitster.siamese.dyndns.org>
	<20070902191644.29d46cd2.seanlkml@sympatico.ca>
	<46DBBD00.5090308@zytor.com>
Date: Mon, 03 Sep 2007 01:10:34 -0700
In-Reply-To: <46DBBD00.5090308@zytor.com> (H. Peter Anvin's message of "Mon,
	03 Sep 2007 08:51:28 +0100")
Message-ID: <7vr6lgmao5.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Sean wrote:
>>
>> Given the comment from David, I suspect your patch is all
>> that's needed; hopefully Peter can give it a quick test.
>
> It sounds like it; I don't know how to test it other than placing in
> the repository and try to upgrade.  It can't be any worse, so I don't
> see any harm in just doing it.

Ok, should I then do that single change, cut 1.5.3.1 with it and
ping you?
