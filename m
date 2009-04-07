Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZDGLZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZDGLZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZDGLZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:25:08 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47060 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbZDGLZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lHXG2CRFsOTnXwt6SXj3eWdcas9ealLyH1JjP13XflId0TUeSTWL10xs1da23ctNvk
         pOViPUS8j+LWfOAkDKCT226RkTTuZ1BL6pwMzZG3q4OLCxrpu2CpbpvaJVA53GTuVPSs
         52HaG+a6iJdVM9ZDPQsEL3YR5x7Ek1GN1PTa0=
MIME-Version: 1.0
In-Reply-To: <1239103411.5300.26.camel@subratamodak.linux.ibm.com>
References: <1239103297.5300.24.camel@subratamodak.linux.ibm.com>
	 <1239103411.5300.26.camel@subratamodak.linux.ibm.com>
Date: Tue, 7 Apr 2009 15:25:05 +0400
Message-ID: <a4423d670904070425y1d38579dv34ba8681c77e43e4@mail.gmail.com>
Subject: Re: Next April 7 : x86 allmodconfig failure [kernel/module.c]
From: Alexander Beregalov <a.beregalov@gmail.com>
To: subrata@linux.vnet.ibm.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       rusty <rusty@rustcorp.com.au>, rusty <rusty@au1.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 Subrata Modak <subrata@linux.vnet.ibm.com>:
> Sorry,
>
> This occurred on April 7th Tree.
>
> On Tue, 2009-04-07 at 16:51 +0530, Subrata Modak wrote:
>> Hi,
>>
>> Following build failure occurs with April 7 next tree on x86, kernel
>> configuration enabled as randconfig.
>>
>> kernel/module.c: In function ‘sys_init_module’:
>> kernel/module.c:2401: error: ‘modules_disabled’ undeclared (first use in
>> this function)
>> kernel/module.c:2401: error: (Each undeclared identifier is reported
>> only once
>> kernel/module.c:2401: error: for each function it appears in.)
>> make[1]: *** [kernel/module.o] Error 1
>> make: *** [kernel] Error 2

Hi

Patch is already sent
http://patchwork.kernel.org/patch/16535/
