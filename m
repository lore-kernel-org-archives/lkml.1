Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbZDAPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbZDAPxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZDAPxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:53:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:44421 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZDAPxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=fO2gOfpXN0aZgD9jQJBNkpWhkxXO0Af/g7tLNAIzeahRzBrCjP869OUDErYfbx9SN8
         6HO4Tnoerie2UaOWja0EasJzzN1f19triVHrLizoRWVq1pfSpTkZlBHFv6PX/sigJr2u
         iY/k8bMCraBeM1b2o8P8rqvnQDGR5AkjSFkWI=
MIME-Version: 1.0
In-Reply-To: <20090401150928.GA5886@denkbrett.schottelius.org>
References: <20090401164450.f8192631.sfr@canb.auug.org.au>
	 <20090401150928.GA5886@denkbrett.schottelius.org>
Date: Wed, 1 Apr 2009 17:52:59 +0200
Message-ID: <1820d69d0904010852qc07ccc7qc9cec18bcc2837bd@mail.gmail.com>
Subject: Re: Invalid module format (was: Re: linux-next: Tree for April 1)
From: Gabriel C <nix.or.die@googlemail.com>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/1 Nico -telmich- Schottelius <nico-linux-next@schottelius.org>:
> Stephen Rothwell [Wed, Apr 01, 2009 at 04:44:50PM +1100]:
>> Hi all,
>>
>> Changes since 20090331:
>
> Same problem since 20090324.

AFAIK it is since 20090218...

>
> arch=amd64, config attached, all modules have that problem.

Disabling CONFIG_MODVERSIONS should workaround this problem.

>
> Sincerly,
>
> Nico

Gabriel
