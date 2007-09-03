Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbXICIN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbXICIN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXICINS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:13:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXICINR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:13:17 -0400
Message-ID: <46DBC1EE.3020009@zytor.com>
Date: Mon, 03 Sep 2007 09:12:30 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Sean <seanlkml@sympatico.ca>, David Kastrup <dak@gnu.org>,
       git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>	<46DA5F33.2020005@zytor.com> <85odgltrtj.fsf@lola.goethe.zz>	<46DA88EF.7080103@zytor.com>	<20070902133803.1b46f599.seanlkml@sympatico.ca>	<7v4picpvgq.fsf@gitster.siamese.dyndns.org>	<20070902191644.29d46cd2.seanlkml@sympatico.ca>	<46DBBD00.5090308@zytor.com> <7vr6lgmao5.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7vr6lgmao5.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> Sean wrote:
>>> Given the comment from David, I suspect your patch is all
>>> that's needed; hopefully Peter can give it a quick test.
>> It sounds like it; I don't know how to test it other than placing in
>> the repository and try to upgrade.  It can't be any worse, so I don't
>> see any harm in just doing it.
> 
> Ok, should I then do that single change, cut 1.5.3.1 with it and
> ping you?

Sounds good to me.

	-hpa
