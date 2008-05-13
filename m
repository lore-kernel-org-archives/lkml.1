Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbYEMJ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbYEMJ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYEMJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:26:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18124 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYEMJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:date:in-reply-to:message-id:user-agent:mime-version:content-type:from;
        b=xKrFdCF+gWDWyAcMnMfWphbz2clAFcXvoqcr4QMBU9SbDlwwjb+Ze/0aeLdpV5e20wZFzro+J3ihlr4JXhaj8wPjZLwqR9v8IsM2SFsIkTC7zYE/MyGRzKzjnUYcgBNICR6O0WRHadphUnRFNJ1Eix24zLDbTtiIWs2rORKpNYQ=
To: Tejun Heo <htejun@gmail.com>
Cc: Harald Arnesen <skogtun.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [Bisected] Latest git will not boot on MacBook
References: <8120cfd40805100705keff68a2kb117aab7d64f76ff@mail.gmail.com>
	<48295773.9030301@gmail.com>
Date: Tue, 13 May 2008 11:26:03 +0200
In-Reply-To: <48295773.9030301@gmail.com> (Tejun Heo's message of "Tue, 13 May
	2008 17:55:15 +0900")
Message-ID: <87fxsmimhg.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Harald Arnesen <skogtun.harald@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Harald Arnesen wrote:
>> See attached photo of screen.
>> git bisect gives this:
>>
>>
>> 78ab88f04f44bed566d51dce0c7cbfeff6449a06 is first bad commit
>> commit 78ab88f04f44bed566d51dce0c7cbfeff6449a06
>> Author: Tejun Heo <htejun@gmail.com>
>> Date:   Thu May 1 23:41:41 2008 +0900
>
> The change was reverted and I'm trying to come up with a better
> version. Thanks.

If you want me to test a new version on my MacBook, let me know.
-- 
Hilsen Harald.
