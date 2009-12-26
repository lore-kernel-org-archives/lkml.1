Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZLZVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZLZVio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZLZVin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:38:43 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40797 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZLZVim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jHRlSbrZpY1xXH1ckORngNisPeYd85k/BdiHDd8buvFmZt5t3+k4l/xuLV4iH2pojc
         2lylvsp04iO9kA9B6NqOe7C+CWmF8oJYAT/1iK+z8U6d5VqMJyNmnDQP9inhZ5adGO9R
         wdWn7h+DtxB2QgqMj9gFxy5o2wNwGV23ZLA94=
MIME-Version: 1.0
In-Reply-To: <20091226133604.7f85a4e7@nehalam>
References: <20091226105821.52d36ba8@nehalam> <8bd0f97a0912261143h48aaaaefw5a83e65120629e75@mail.gmail.com> 
	<20091226133604.7f85a4e7@nehalam>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 26 Dec 2009 16:38:21 -0500
Message-ID: <8bd0f97a0912261338w62b810bdh3e660ae61b8ae975@mail.gmail.com>
Subject: Re: [ANNOUNCE] iproute 2.6.32 released
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 16:36, Stephen Hemminger wrote:
> On Sat, 26 Dec 2009 14:43:10 -0500
> Mike Frysinger <vapier.adi@gmail.com> wrote:
>
>> On Sat, Dec 26, 2009 at 13:58, Stephen Hemminger wrote:
>> > This version of iproute2 utilities includes the changes necessary to support all the features in
>> > 2.6.32, but should be backward compatible with older releases. Lots of bug fixes and little
>> > things, the main area of change is around the always problematic 'ip route flush' interface.
>> >
>> > The tar ball is available at:
>> >  http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.31.tar.bz2
>>
>> URL and git says 2.6.31, but subject says 2.6.32, so i'm guessing
>> subject is the typoe
>
> Actually, the url is typo

there is no 2.6.32 tarball in the dir indicated by the URL.  there is
however a 2.6.31 tarball dated today.
-mike
