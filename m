Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbXCJV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbXCJV5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXCJV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:57:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:36150 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXCJV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dxWUZZr0svvyNdoyKCEwkyOmPMvKJLzGFpbA8ZnMKWvJ3/+O9cSWbBAhRKMjCNII1bi9cdjBX1Z+JSqg+AKyKeyqfF6Xw2yhEuDBOYbveiu6omu0ACHRdfm8cOtsg+zI4G68I4DijHBK+0uhNB18r6jChXhD41S3hqir41VOCWY=
Message-ID: <b14e81f00703101356s248bd914m91c26e2d22e507d4@mail.gmail.com>
Date: Sat, 10 Mar 2007 16:56:57 -0500
From: "michael chang" <thenewme91@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [ck] Re: RSDL v0.28 for 2.6.20
Cc: "Stephen Clark" <Stephen.Clark@seclark.us>, "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070310191118.GL943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703101845.59497.kernel@kolivas.org>
	 <45F2F45F.6000403@seclark.us> <20070310191118.GL943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/07, Willy Tarreau <w@1wt.eu> wrote:
> BTW, Con, I think that you should base your work on 2.6.20.[23] and not
> 2.6.20 next time, due to this conflict. It will get wider adoption.

Maybe I'm naive, but I find this hard to understand -- 2.6.20.2 didn't
exist when Con published his patch. (Con published it ~12 hours before
the release of 2.6.20.2, from what I can tell.) How can he base his
work on something that didn't yet exist? (And it applied cleanly to
2.6.20.1, the latest when he published it.)

That said, being able to easily apply it to the latest stable kernel
would probably increase adoption, yes. I will agree with that much.

-- 
~Mike
 - Just the crazy copy cat.
