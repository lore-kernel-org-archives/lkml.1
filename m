Return-Path: <linux-kernel-owner+w=401wt.eu-S1031080AbXEDQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031080AbXEDQZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031346AbXEDQZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:25:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:41117 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031080AbXEDQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Cz4Eows5AggP/WBR3ZHOJah9ah5zAEpt4kU84fLqwXMCDeBrS91/DMqJ2vJiUdIOfxLLEXFmT9ltsCtqs5P3Z/tyHvUccD3xFrluX/Zrfz2gqGaYui/UY6zJ5quDI/G854SJjy7Q+ix5MdowuVoRi01Kw0ve1p3JWZoCDtRvAZU=
Message-ID: <463B5E4F.2060900@gmail.com>
Date: Fri, 04 May 2007 18:24:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch]clarification of coding style regarding conditional statements
 with two branches
References: <200705040926.55257.oliver@neukum.org> <463B47AF.4010503@gmail.com> <200705041729.04771.oliver@neukum.org>
In-Reply-To: <200705041729.04771.oliver@neukum.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum napsal(a):
> Am Freitag, 4. Mai 2007 16:48 schrieb Jiri Slaby:
>> Why, what's wrong with
>> if (condition) {
>>         do_this();
>>         do_that();
>> } else
>>         otherwise();
>>
>> ? It's more readable/nicer in my eyes than
> 
> Than I am afraid we need to agree to disagree. But then I would
> insist that neither side give the other a hard to time over this issue.

Then I would just let it undefined to let subsys maintainers (or coders
themselves) to decide what they want in their subtree like ton of other things...

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
