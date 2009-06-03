Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZFCVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZFCVv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZFCVvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:51:52 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:48561 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZFCVvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:51:51 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 17:51:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xJE+BTPAJJOEqE9PLYuIfwxN6VY1MupKq0f45ZhLBEy+RKWmyhTfmzkOago3ryn5Yw
         rDyIrU0itllA81im1nt8VgCRyVx8J5ebBcos85gLqPvjxMhcR27uOxmwn+WBbMwEZ8SW
         /v/zCCMnzLYwlTZVbvMT103M2RxUP7NkZQ1mQ=
MIME-Version: 1.0
In-Reply-To: <957183.51083.qm@web50101.mail.re2.yahoo.com>
References: <957183.51083.qm@web50101.mail.re2.yahoo.com>
Date: Thu, 4 Jun 2009 06:44:38 +0900
Message-ID: <49b7c2350906031444p1949dd08y5f5bb0c9f33df47a@mail.gmail.com>
Subject: Re: [PATCH V2] Fix the meaning of EDAC abbreviation
From: GeunSik Lim <leemgs1@gmail.com>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 11:54 PM, Doug Thompson <norsk5@yahoo.com> wrote:
>>  menuconfig EDAC
>> -    bool "EDAC - error detection and
>> reporting"
>> +    bool "EDAC(Error Detection And
>> Correction) reporting"
>>      depends on HAS_IOMEM
>>      depends on X86 || PPC
>>      help>
> Ok, even better. It covers both contexts
Thanks  for your reply.




-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
