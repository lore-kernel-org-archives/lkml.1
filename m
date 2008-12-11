Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYLKT6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYLKT6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYLKT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:57:53 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:22467 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYLKT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ML/8AVDOBF9FyuXKkWtDebasvtKq85D/Tm2SMooy7+j7+n/ssRP2ceh0XGDe02EBic
         2UsDGZq2AHKJjIFN68SltiMFAYfmI7S7d7YV3yadEIyjSPn3im+ClwtBAj8ePNwg07la
         9vhjx4ZWLSKzBKCS2Y4rDFrtuHjmKetCq0pe4=
Message-ID: <8bd0f97a0812111157m25eabf96se31af9bc35beebf0@mail.gmail.com>
Date: Thu, 11 Dec 2008 14:57:50 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: breakage in linux-next sound/soc/blackfin/bf5xx-i2s.c
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081211161402.GA24645@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0812110802k1faa1c67tc81b4bb5282a3d17@mail.gmail.com>
	 <20081211161402.GA24645@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:14, Mark Brown wrote:
> On Thu, Dec 11, 2008 at 11:02:24AM -0500, Mike Frysinger wrote:
>> your recent change 3f4b783cfd (ASoC: Register platform DAIs) is
>> incorrect for sound/soc/blackfin/bf5xx-i2s.c.
>
> Fixed, thanks.

you did the work, thanks for fixin ;)
-mike
