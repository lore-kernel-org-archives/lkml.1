Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYGUJHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYGUJHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYGUJG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:06:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42984 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYGUJG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=jtfOMr0cytaQPj30Z4ubQg0iyt2uM47PSjimR/YVPa8ncQYD4eCM7gcQ2jDFZFqwE8
         Ifk1XD8+2lGBeCefA1OWHLo9iloQTQg9au7iQNG1siuQCmybcgM2cbGuh7+YDWjE1y4t
         vNn1ekg38trbHm/22gE4VN1uC64onCtS9zU2Q=
Message-ID: <84144f020807210206r12b121c6o8ce88a752493b0cf@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:06:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] vfs: use kstrdup()
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48844FE4.1040708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus>
	 <20080719131909.GB7027@asus>
	 <20080721052713.GY28946@ZenIV.linux.org.uk>
	 <48842CDB.1090009@cn.fujitsu.com>
	 <20080721070346.GA28946@ZenIV.linux.org.uk>
	 <20080721080427.GC6662@lenovo> <488448A1.3030608@cn.fujitsu.com>
	 <20080721084443.GD20011@lenovo> <48844FE4.1040708@cn.fujitsu.com>
X-Google-Sender-Auth: 98042ac17f83f4cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 21, 2008 at 11:59 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> well, as only Al find new version more or less correct we could
>> update yours.
>
> Sorry, I don't quite catch what you mean for my poor English. :(
>
> Do you expect me to update and resend my version? or do you mean don't
> drop the patch in -mm but you will resend a patch based against it?

Andrew already merged your patch so I think Cyrill should just send a
new patch against -mm.

                          Pekka
