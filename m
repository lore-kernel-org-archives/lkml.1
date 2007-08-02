Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbXHBDBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbXHBDBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbXHBDBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:01:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:25274 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXHBDBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HZQWCACbws2TD39PqUUhDFDBKYdMUOPmfST0ReQUUBHZipSCqeZ40ZjX9YNMwr8wvfehHk4YHRFTB+RqD33rj08dd/1O2F2sYwTvXjinJ4qHrGqvL63JZrn7kLUvxWJWWVj6M//2xWNF5OWR53YMW4k2Pm5HAHcrJAsx6D1HobI=
Message-ID: <46B148AB.4020401@gmail.com>
Date: Thu, 02 Aug 2007 11:59:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 026 of 35] Split any large bios that arrive at __make_request.
References: <20070731112539.22428.patches@notabene>	<1070731021804.25499@suse.de>	<20070801175636.GJ13674@htj.dyndns.org> <18097.10790.205449.176104@notabene.brown>
In-Reply-To: <18097.10790.205449.176104@notabene.brown>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Thursday August 2, htejun@gmail.com wrote:
>> Hmmm... Patches don't apply beyond this one.  I'm applying against
>> clean 2.6.23-rc1-mm1 grabbed using ketchup.
>>
> 
> So do you mean 027 doesn't apply, or that 028 doesn't apply next?
> 
> It is possible that you missed 027.  It originally has 3 consecutive
> Xs in the subject line, so vger.kernel.org bounced it.
> I re-sent it, but it would have had a different References header and
> the might not appear in the same thread.
> 
> If you confirm that 027 isn't applying, I'll track down what happened.

You're right.  I don't have patch 27.  Looking.... Ummm... It's not in
my LKML folder either.  Can you resend it?

Thanks.

-- 
tejun
