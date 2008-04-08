Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYDHL2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYDHL2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYDHLTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:55 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:34647 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYDHLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:54 -0400
To: "Andreas K. Huettel" <mail@akhuettel.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [tainted,fglrx] page allocation failure: basic meaning of log messages?
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LNX.1.00.0804031117030.10277@localhost>
	<20080403183021.028C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<alpine.LNX.1.00.0804031318480.10277@localhost>
	<20080403144852.GD24239@csclub.uwaterloo.ca>
	<1207234830.8514.838.camel@twins>
	<alpine.LNX.1.00.0804081125140.22515@localhost>
Date: Tue, 08 Apr 2008 13:19:49 +0200
In-Reply-To: <alpine.LNX.1.00.0804081125140.22515@localhost> (Andreas K. Huettel's message of "Tue, 8 Apr 2008 11:39:38 +0200 (CEST)")
Message-ID: <87r6dgpp9m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2008 11:13:06.0690 (UTC) FILETIME=[854A1620:01C89969]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andreas K. Huettel" <A.K.Huettel@tudelft.nl> writes:

> Question - this seems to me not to be a kernel issue (correct me if I'm 
> wrong) and thus I'd like to take it to the proper place...
> Where should I file this as bug? Is this a hald problem or something more 
> complicated?

It is a firegl bug. You should report it to ATI

-Andi
