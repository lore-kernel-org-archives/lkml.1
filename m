Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZIIAoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZIIAoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZIIAoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:44:13 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:49998 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZIIAoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:44:13 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [long] Another BFS versus CFS shakedown
Date: Wed, 9 Sep 2009 02:44:13 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
References: <200909090142.41738.elendil@planet.nl>
In-Reply-To: <200909090142.41738.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909090244.14339.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2009 00:44:14.0672 (UTC) FILETIME=[A7A54D00:01CA30E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, Frans Pop wrote:
> BFS general impression
> ----------------------
> I've used BFS for over a day yesterday and today, and in general I'm
> very impressed. During normal use (coding and testing a shell script
> that's CPU/memory heavy + normal mail/news/browser + amarok) I've not
> seen any strange issues. My notebook even suspended and resumed (StR)
> without any problems.
>
> With CFS I regularly have short freezes of the mouse cursor or when
> typing. I think that it's related to KDE's news reader knode updating
> from my local news server. With CFS I also saw such freezes a few
> times, but they _seemed_ less frequent and less severe. No hard data
> though.

The 2nd CFS should have been BFS here. Sorry.

> But this evening, while I was preparing and running the tests, I've had
> 4 freezes of the desktop. The first two times it was only a partial
> freeze: taskbar was frozen, but I could still switch apps and use the
> graphical console; the last two times it was a full freeze of the
> display and keyboard (incl. e.g. numlock), but in the background
> everything continued to run normally and I could log in over SSH
> without any problem. On reboot some file systems did fail to unmount
> though.
>
> Normally my desktop and X.Org are 100% reliable.

Cheers,
FJP

P.S. I've received a very positive and friendly private reply from Con.
