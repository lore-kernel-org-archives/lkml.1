Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZAEQue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZAEQue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZAEQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:49:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:65447 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZAEQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q2oPkUJg9vFYCS5ZBSq74gEfxtVKG8NvIpOhACy7TO6kyLjbBpfop2nwI5hegLZEdB
         TyDS2dnZqmyEg6zTcHx6GfkxGhjf4DdZZ7p2iiHjPiSktKg6RGWGl4bTrtGMpXfhh22L
         ufPHQPfd22rsiTFpwV/xOExXZp8t5iDnDOmnA=
Message-ID: <a00b9da20901050849k512512cfg120e97beef3edaae@mail.gmail.com>
Date: Mon, 5 Jan 2009 17:49:55 +0100
From: "Frank Groeneveld" <frankgroeneveld@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: Kernel 2.6.28 regression: Hang after hibernate (patch included)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Pavel Machek" <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <a00b9da20901041244h7a2146a3l93df6c9935613cae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
	 <a00b9da20901020910i2625073av96ce68ec0c313a8c@mail.gmail.com>
	 <a00b9da20901021118h3e698d04q33fa9e87519e4d42@mail.gmail.com>
	 <200901022318.45675.rjw@sisk.pl>
	 <20090104192502.GA6196@electric-eye.fr.zoreil.com>
	 <a00b9da20901041244h7a2146a3l93df6c9935613cae@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 Frank Groeneveld <frankgroeneveld@gmail.com>:
> 2009/1/4 Francois Romieu <romieu@fr.zoreil.com>:
>> [...]
>>
>> Frank, can you:
>> 1. try the r8169.c file from the 2.6.28 tree with Ubuntu's kernel

This results in a fine working system. Resume and hibernate work just
the way they should.

Frank
