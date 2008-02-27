Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbYB0VsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbYB0VsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbYB0VsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:48:17 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:52550 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbYB0VsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:48:16 -0500
Message-ID: <47C5DA71.5080506@student.ltu.se>
Date: Wed, 27 Feb 2008 22:47:29 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, khc@pm.waw.pl,
       bhalevy.lists@gmail.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] CodeStyle: Use spaces when aligning/decorating
References: <1204062430.47c488def40a4@portal.student.luth.se>	 <20080226135444.f83a0536.randy.dunlap@oracle.com>	 <47C48FD8.5040205@student.ltu.se> <b6c5339f0802271333u3d9ad05dk26b30d59f1b41a75@mail.gmail.com>
In-Reply-To: <b6c5339f0802271333u3d9ad05dk26b30d59f1b41a75@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
>>  > FWIW I prefer the {deleted} language.  // PI = 3;
>>  >
>>  Well, actually I like it too. But I think it should be up to the
>>  programmer which setting to use + it seems some people have really taken
>>  this to heart, going from 'tab => 8 characters wide' to '8 spaces =>
>>  tab', obscuring tab's position as a 'logical indention'.
>>     
>
> Well, no one's saying that you can't configure your editor any way you
> want.  The tabs=8 is a good cue for the 80-column rule, though.
>   
The problem isn't "should tab be <any number> wide", it is those who 
want to force replacement of alignment-spaces with tabs (aka 
checkpatch.pl). Also, the 80-rule is not really effective if not using 
8-wide tabs ;)
> IMO, CodingStyle used to be a good, funny read and now it's just simply
> full of boring pedantic laws.
>   
Unfortunately...

