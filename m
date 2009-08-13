Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZHMV3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZHMV3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZHMV3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:29:50 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:58362 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZHMV3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:29:50 -0400
References: <20090813121722.48988dfc.peter@piie.net> <20090813135648.77c99f68.akpm@linux-foundation.org>
Message-ID: <cone.1250198719.400680.26378.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, petkovbb@googlemail.com, lenb@kernel.org,
       andi@lisas.de
Subject: Re: [PATCH 1/2] acerhdf: convert to dev_pm_ops
Date: Thu, 13 Aug 2009 23:25:19 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Thu, 13 Aug 2009 12:17:22 +0200
> Peter Feuerer <peter@piie.net> wrote:
> 
>> acerhdf: convert to dev_pm_ops
>> 
>> v 1.1:
>> Add .freeze func ptr to support suspend-to-disk,
>> as suggested by Dmitry Torokhov.
>> 
>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>> Signed-off-by: Peter Feuerer <peter@piie.net>
>> Cc: Andreas Mohr <andi@lisas.de>
>> Cc: Len Brown <lenb@kernel.org>
> 
> I believe that Boris wrote this, yes?

Yes, Boris wrote the patch.

> 
> The way this patch/email was presented implies that you were the
> primary author.
> 
> Please use an explicit From: line right at the top of the changelog
> (after all the mail headers) to explicitly identify the primary author.
> 
> I added a
> 
> 	From: Borislav Petkov <petkovbb@gmail.com>
> 
> to my copy of this patch.  Please let me kow if that was incorrect.

Thank you very much for adding this line. And thanks for teaching,.. yet 
another thing I've learned from you :)

--peter

