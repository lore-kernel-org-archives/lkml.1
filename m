Return-Path: <linux-kernel-owner+w=401wt.eu-S965340AbXAYNXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340AbXAYNXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965334AbXAYNXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:23:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:32172 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965340AbXAYNXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=o4adQJ36zvBzLqFdcDBjNQhtAGrFT20PUVTLN41qg7+K0rkRp1oFuEokvYaGAIOVTkqSSDmt39rJEdh9DnqhDNN2Cm8VVZ/Be3oR9879l+VpeNOwjcMJjatbHbRJWEOCiTM2AkM3Z8uWzE06sNeHCdHJ6JGzu6gWojUNLv4P0+E=
Message-ID: <b681c62b0701250523w14f0d0efl78b1ab3be7693c31@mail.gmail.com>
Date: Thu, 25 Jan 2007 18:53:29 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Excessive printks increase top mem usage?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject is updated

On 1/25/07, yogeshwar sonawane <yogyas@gmail.com> wrote:
> Hi all,
> I am running a user application which will just open/close my driver
> (simple one, empty functions with only printks) infinitely.
> A massive use of printk can slow down the system noticeably OR it can
> affect some time calculations.
> Apart from this, it was increasing top mem usage also. After closing
> the application, the memory consumption was not coming down(not
> freeing mem). Is this the expected behaviour? OR i am missing
> something?
>
> Can anybody help me in guiding the reason for this? Any help/links plz.
>
> Thanks in advance,
> Yogeshwar
>
