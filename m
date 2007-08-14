Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbXHNPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbXHNPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761942AbXHNPpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:45:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:6020 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbXHNPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D4pFGGeSBar7A7pk2Ue0ifrtLZqz1/yx629XKBHB1uGQHK/bO6TGlhxUR98mPaOkHFvUDXxNzL01ZItJ9C6KbikcmXtOFLGrsPy1gewfzaT4szqsF4Mt0jmGBcfugUmxEaSPZTHR7qmAuFP8PHP5bn5HCmjENMrgfw+YtEsR1XU=
Message-ID: <6bffcb0e0708140844x1aabaa63k5aba807961950462@mail.gmail.com>
Date: Tue, 14 Aug 2007 17:44:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: 2.6.23-rc3 - CONFIG_VMI broken
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>, zach@vmware.com,
       rusty@rustcorp.com.au
In-Reply-To: <82e4877d0708140839y3550bfa6of6a369251db517f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0708140839y3550bfa6of6a369251db517f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Parag,

On 14/08/07, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> CONFIG_VMI seems to be broken, but I am not sure when - the last
> kernel I was running was 2.6.22-rc4 which used to boot fine and use
> VMI.

Please check the latest -stable and let me know if it is a regression.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
