Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936239Ab0BZNb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:31:59 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:51936 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936209Ab0BZNb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JYYZ5Z8DKsojztmwV4biwuU3v6BSIm3LdqsiKf8SZCRkn15kXZHwmGhR5VFRwwgT0C
         MB59TiR1zlpy7eb+bd84LzT1SSPmQ1K8RkF+HkqAIV1Wrq6YorSxt9eZCaJQHvLv0m9h
         pjfzuXmgst3p3UBsCc/Hqp61Bp6RiUy7QaKRE=
MIME-Version: 1.0
In-Reply-To: <F56EA673D3E56E48804FE2B0D23EFD2D21346D8A9D@KCINPUNHJCMS01.kpit.com>
References: <F56EA673D3E56E48804FE2B0D23EFD2D21346D8A9D@KCINPUNHJCMS01.kpit.com>
Date: Fri, 26 Feb 2010 19:01:56 +0530
Message-ID: <5d5443651002260531r1f51cfa7y9c778952974cda79@mail.gmail.com>
Subject: Re: Touch Screen Drivers for Dialog da9052
From: Trilok Soni <soni.trilok@gmail.com>
To: Nitin Shah <Nitin.Shah@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-input mailing list.

On Fri, Feb 26, 2010 at 6:06 PM, Nitin Shah <Nitin.Shah@kpitcummins.com> wrote:
> Hi,
>
> We have developed Touch Screen (TSI) Drivers for Dialog da9052 Power Management IC.
>
> We have tested this driver on Samsung SMDK-6410 board. If any one needs test application tor testing this driver, we will provide the same which we have used for testing.
>
> For more details about the attached drives please refer the README file inside "da9052_drivers.zip".
>
> We would like to incorporate this driver into Linux mainline kernel.
>
> Please test the driver and provide your valuable comments and feedback.

Please don't send .zip files. It would be nice if you can send inline
patches to linux-input ML. Please refer Documentation directory for
instructions on submitting patches.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
