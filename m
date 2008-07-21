Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYGUJRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYGUJRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYGUJQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:16:58 -0400
Received: from mail.lang.hm ([64.81.33.126]:44664 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbYGUJQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:16:57 -0400
Date: Mon, 21 Jul 2008 02:18:03 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: el es <el_es_cr@yahoo.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
In-Reply-To: <loom.20080721T074322-56@post.gmane.org>
Message-ID: <alpine.DEB.1.10.0807210216260.1125@asgard.lang.hm>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr> <20080720181426.GA29189@1wt.eu> <loom.20080721T074322-56@post.gmane.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, el es wrote:

>>
>> also, causes trouble when stable releases cross a year boundary, or
>> when there are several ones in a week. The stable release should
>> only be a counter, not a date.
>>
>> Willy
>>
>>
>
> If there are more stable releases in a week, you could put a release counter
> after a dash, say : 2.08.30.40-[2...X]
>
> If stable continues to be used and leaps over to next year, put another .yy.ww
> section : 2.08.30.09.02
>
> OK I know that's long, but easy to expand if needed, just be sure to separate
> date pieces with dots and counters with dashes. Or...
>
> maybe use them the other way round - the current scheme uses counters separated
> by dots, so maybe the new could do ss.yy-ww-tt[[-yy]-ww][.X]] ? Like
> 2.08-30-40.2 ? 2.08-30-09-02.2 ? But this seems odd, even to me ;)

you are well past the point where the complexity overwelmes the 
information you are providing.

does it really matter _exactly_ when a release was made?

David Lang
