Return-Path: <linux-kernel-owner+w=401wt.eu-S935363AbYBAFCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363AbYBAFCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935583AbYBAExn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:53:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:13603 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935266AbYBAExl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:53:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ViwIXM3OuzdC+Da7uIvA+4kZE6vBv3VCd11s3SJsiLp39B1fo1oH2krZwqGAsUn5ond6OxaH7o8manTx1eXRjVmOjJaDXjBzcNmRI9M2qql4rhCFaV0+oiaYMUxEQsH2SIlGcUZUCOel8Nq2E1Gxq/Zl7vUbW0MzOuRdmJJqmEk=
Message-ID: <75b66ecd0801312053h6e736edfw2c757528ac9dea4d@mail.gmail.com>
Date: Thu, 31 Jan 2008 23:53:40 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Reinaldo Carvalho" <reinaldow@gmail.com>
Subject: Re: missing asm-x86_64 detection
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
X-Google-Sender-Auth: a049e53e7e846dfc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 6:13 PM, Reinaldo Carvalho <reinaldow@gmail.com> wrote:
> system is x86_64!
>
> :/# grep model\ name /proc/cpuinfo
> model name      : AMD Turion(tm) 64 X2
> model name      : AMD Turion(tm) 64 X2

What does "head -20 /usr/src/config-2.6.24" say?

Lee
