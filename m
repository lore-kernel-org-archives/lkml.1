Return-Path: <linux-kernel-owner+w=401wt.eu-S935495AbYEBSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495AbYEBSTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762226AbYEBSTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:19:47 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:40263 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761396AbYEBSTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:19:46 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       "Parag Warudkar" <parag.warudkar@gmail.com>,
       "Adrian Bunk" <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
From: Andi Kleen <andi@firstfloor.org>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
	<82e4877d0805021030s793835a1le0032673b0f4c6c7@mail.gmail.com>
	<200805021344.59492.dhazelton@enter.net>
	<200805021948.48345.rjw@sisk.pl>
Date: Fri, 02 May 2008 20:18:03 +0200
In-Reply-To: <200805021948.48345.rjw@sisk.pl> (Rafael J. Wysocki's message of "Fri, 2 May 2008 19:48:47 +0200")
Message-ID: <877iecvack.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 18:11:08.0959 (UTC) FILETIME=[E5669AF0:01C8AC7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> And I have to agree here. But there should be something that can be done 
>> to "coax" the maintainers that pull that kind of immature crap into acting 
>> mature and responsible.
>
> Well, how exactly would you want to do that?

He could start to fix a few such bugs he's describing (usually with
very vague reports) by himself. Or instead of fixing them just trying
to get all the information out of the reporter. Then he would realize
what the the difference between theory and practice is.

-Andi
