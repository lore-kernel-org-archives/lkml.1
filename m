Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZIUVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZIUVOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZIUVOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZIUVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:14:16 -0400
Message-ID: <4AB7EC8E.80708@zytor.com>
Date: Mon, 21 Sep 2009 14:13:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253561749.2934.47.camel@localhost>
In-Reply-To: <1253561749.2934.47.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> On Mon, 2009-09-21 at 12:26 -0700, H. Peter Anvin wrote:
>> Could you please do a git bisect on this problem?
> 
> Would love to, but how do I convert g99bc470 to a correct git revision
> number please?
> 
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect start
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect bad
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect good g99bc470
> fatal: Needed a single revision
> Bad rev input: g99bc470
> 

Drop the leading "g" (which stands for git).

	-hpa

