Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZDZD5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZDZD5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDZD5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:57:36 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:48289 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZDZD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oV970Hh0iny/D52TmWrVT6yRIQc0uM75Y9o9f7jVAzSCmuy6Qjj8KTWwnlFx3SB3Zg
         YE+Q67YtJd4G9PJCEGrO6aUeKmmcvoyb0ug9OqSSumb+q7s5cUOHfAiuXJrvHN/ysJd4
         XM2QTAxrR8MhMMsLzjIPwRaZSBmyjg1XooQxk=
Message-ID: <49F3DBE7.4030905@gmail.com>
Date: Sun, 26 Apr 2009 12:58:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update IDE entry
References: <200904232248.31735.bzolnier@gmail.com> <200904241154.04860.bzolnier@gmail.com> <9ea470500904240941s53f41b2dq1c4e5bc85b6244d7@mail.gmail.com> <200904242121.16910.bzolnier@gmail.com> <20090425092816.GA6212@liondog.tnic>
In-Reply-To: <20090425092816.GA6212@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Fri, Apr 24, 2009 at 09:21:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> Moreover, I would prefer getting patches which don't need updating. ;-)
> 
> Sounds like a good idea, let's do that! :0)
> 

Great.  :-)

To rebase or not seems to be an issue people have different opinions
about.  Some trees get rebased regularly while others seldomly or
never.  Not being a maintainer, I prefer trees which don't get rebased
but being able to provide cross-tree sync points is one of the biggest
benefits and as long as they can be established when necessary, I
guess to-each-his/her-own.

Thanks.

-- 
tejun
