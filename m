Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZJHKvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZJHKvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZJHKvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:51:41 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35201 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbZJHKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hzQmkhP78YRIupcQrkI2J0qHKlttTtvK7cmyKxw1o1s+xW2sG8g9dWLxfwZKnD+eS4
         1v9F+t56lTphDl/feO1n1QWxxNVyfEOWYd3ZPOwn1w5JtXH2W4mH+w+wMVFa1Wk2KgtE
         5YbqHeiMI9+u/wlFma3ImEsJP6j4jfdOyLzCs=
MIME-Version: 1.0
In-Reply-To: <cdb43e8a0910080331l1faa426cq9c2e1e0467003ec9@mail.gmail.com>
References: <haj471$fn8$1@ger.gmane.org>
	 <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
	 <haj8uj$fn8$2@ger.gmane.org>
	 <a8e1da0910072255r38f95e59lf9559b4ecd1cc9d2@mail.gmail.com>
	 <cdb43e8a0910080331l1faa426cq9c2e1e0467003ec9@mail.gmail.com>
Date: Thu, 8 Oct 2009 18:51:03 +0800
Message-ID: <a8e1da0910080351w4fe8827eyd583eb903748ed92@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Dave Young <hidave.darkstar@gmail.com>
To: Jack Byer <ojbyer@usa.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 6:31 PM, Jack Byer <ojbyer@usa.net> wrote:
>> Could you post the header part of the cd? ie:
>>
>> dd if=/dev/cdrom of=header bs=1k count=32
>>
>

Sorry, my mistake, getting the meta data we need at least 64k.

Could you send again the header?

dd if=/dev/cdrom of=header bs=1k count=64

-- 
Regards
dave
