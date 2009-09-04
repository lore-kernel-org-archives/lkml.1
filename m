Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZIDQvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZIDQvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZIDQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:51:51 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:48451 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZIDQvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VsofsvXq8V0qJK/FWwKtQWGNfivfF9dSAGLkSRNZb39nT1JXKJbqsI5XfQxNlXZfeV
         tnVfLlfV6UpsC8d5lPLnGvMV/6paxxN4FR35uauSoJXXyczlE9SbTG177ThFicbRPg8O
         eXSTCIXDjrsLX8gLM5LnOa7tdOwILGTLJYoDI=
MIME-Version: 1.0
In-Reply-To: <1252081080.31087.7.camel@skunk>
References: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com> 
	<1252065236.14338.179.camel@skunk> <1252080405.24673.11.camel@mj> 
	<1252081080.31087.7.camel@skunk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Sep 2009 09:51:32 -0700
Message-ID: <43e72e890909040951y6a1e639bl771a63389665ca2a@mail.gmail.com>
Subject: Re: Atheros Linux wireless drivers home page - and two new driver 
	projects
To: Xavier Bestel <xavier.bestel@free.fr>, Dan Williams <dcbw@redhat.com>,
       Witold Sowa <witold.sowa@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Len Widra <Len.Widra@atheros.com>,
       Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Werner Almesberger <werner@openmoko.org>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       Nick Kossifidis <mickflemm@gmail.com>,
       Bob Copeland <me@bobcopeland.com>, Greg KH <greg@kroah.com>,
       rshlinux@gmail.com, b_yogesh_snowy@yahoo.com,
       Michael Renzmann <mrenzmann@madwifi-project.org>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       Paul Fertser <fercerpav@gmail.com>, Harald Welte <laforge@openmoko.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 9:18 AM, Xavier Bestel<xavier.bestel@free.fr> wrote:
>
> On Fri, 2009-09-04 at 12:06 -0400, Pavel Roskin wrote:
>> On Fri, 2009-09-04 at 13:53 +0200, Xavier Bestel wrote:
>> > On Thu, 2009-09-03 at 15:54 -0700, Luis R. Rodriguez wrote:
>> > > I'm pleased to announce the new home page to Atheros Linux wireless drivers:
>> > >
>> > > http://wireless.kernel.org/en/users/Drivers/Atheros
>> >
>> > ath5k is marked as not master-mode capable. I thought this had been
>> > fixed for 2.6.31 ?
>>
>> The above page makes no such statements.  I have fixed
>> http://wireless.kernel.org/en/users/Drivers/ath5k
>
> Right, thanks.
>
>> https://madwifi-project.org/wiki/UserDocs/ath5kAccessPoint still needs a
>> lot of work, or maybe it should be removed as obsolete.
>
> Yes, I miss access-point functionality in NetworkManager :)

BTW a GSoC project this year was to add AP support to Network Manager.
As far I can tell the Witold Sowa finished this so you should be able
to test this.

Witold, can you update the wiki page on this project with details as
to how people can test this?

http://wireless.kernel.org/en/developers/GSoC/2009/Add_AP_Support_to_Network_Manager

  Luis
