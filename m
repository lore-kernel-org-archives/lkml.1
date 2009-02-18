Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZBRMhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZBRMhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZBRMgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:36:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:54229 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZBRMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LsAKPxvEtuDdL+blFsU7DvsJ23Kf3yLzMxZG0CybNeDvhTBYVPoKEK+prMQXr3uEey
         3N3dLIfKWnU5FfKb/MYI8N5m1k/H20PyO87VIPtFqy5rQu8klMrKqqISygWQWR4II8Kn
         EftKy7uRzvcM5/vA4xFWObNckQ+Lu8n49bhnE=
MIME-Version: 1.0
In-Reply-To: <1234960267.4637.62.camel@laptop>
References: <20090218212730.dde6942b.minchan.kim@barrios-desktop>
	 <1234960267.4637.62.camel@laptop>
Date: Wed, 18 Feb 2009 21:36:52 +0900
Message-ID: <28c262360902180436i47f69578h2b6bce69cd2b4df@mail.gmail.com>
Subject: Re: [PATCH v2] perfcounters: clean up rotate_percpu
From: MinChan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 9:31 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-02-18 at 21:27 +0900, MinChan Kim wrote:
>> Ingo implemented rotate function at 235c7fc7c500e4fd1700c4ad01b5612bcdc1b449.
>> I think he want to implement rotate_percpu but he don't implement it yet.
>>
>> If we need not it immediately,
>> It would be better to remove it until we will need it again.
>
> It seems to me, a more constructive patch would be to implement it for
> him.

If it is his intention, I don't care about this patch commit. :)

-- 
Kinds regards,
MinChan Kim
