Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0CJCIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:08:09 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:36435 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab0CJCIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wrMecEITdzEPuUUmq6KJZs+T9gP1GES3zYEB6V7HaLowDArWOuqJRq7lyjktpQUBaD
         JFP36ecGi0wPEiFAeTG4XYqgYHTUC4NMSE1ZO2JXLGIgcGGKyaKymK/xMdRJSoYci6xy
         EAITmnWWaVHQDpb/We1ZxxcZH9MA9QCDogtYg=
MIME-Version: 1.0
In-Reply-To: <4B968834.3040609@gmail.com>
References: <4B968834.3040609@gmail.com>
Date: Wed, 10 Mar 2010 11:08:04 +0900
X-Google-Sender-Auth: 17363b87679a8807
Message-ID: <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
From: Yuasa Yoichi <yuasa@linux-mips.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
> Ramoops, like mtdoops, can log oops/panic information but in RAM.

What is different from mtdoops + mtd-ram?

Yoichi
