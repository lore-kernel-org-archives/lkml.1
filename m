Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbZKAAEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbZKAAEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 20:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbZKAAEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 20:04:32 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:47730 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbZKAAEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 20:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mvtHgyCI5or8awkriEYdPJ8M8LWoW7NIofIMftGlBJL9MIncPp9Vpav8yVTUXNkkFV
         d3iLKORHbYN9E2R9LgKyRpPVvxl3LdaxdVQvRZnbE4T8meiZ/xRLtBCB3SRsL3Yjp7gX
         HqMvRSd943wjTeyeFLn8es8i7z8pnI6zE2abw=
MIME-Version: 1.0
In-Reply-To: <4AEC27AD.9060400@imap.cc>
References: <b8bf37780910310240i55ec5e0ag74fee707bb4f5a8a@mail.gmail.com>
	 <4AEC27AD.9060400@imap.cc>
Date: Sat, 31 Oct 2009 22:04:37 -0200
Message-ID: <b8bf37780910311704r7ee5e3bcw230e0e0d5f2f6c52@mail.gmail.com>
Subject: Re: [PATCH 01/16] trivial: fix assorted "success" typos
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/09, Tilman Schmidt <tilman@imap.cc> wrote:
> Am 31.10.2009 10:40 schrieb André Goddard Rosa:
>> Subject: [PATCH 01/16] trivial: fix assorted "success" typos
>>
>> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>>
>> diff --git a/Documentation/ABI/testing/procfs-diskstats
>
> Please provide a diffstat for that kind of patches in the future.
> I don't want to scan sixteen patches in their entirety just to
> make sure none of them touches the little driver I maintain.
>

No problem, I will do it next time.

Thanks,
André
