Return-Path: <linux-kernel-owner+w=401wt.eu-S932711AbZJAOqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbZJAOqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbZJAOqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:46:32 -0400
Received: from mail-iw0-f190.google.com ([209.85.223.190]:38418 "EHLO
	mail-iw0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbZJAOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:46:31 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 10:46:31 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CqcTpnGQ4jXUYa6qqzpKTmK2r8eEfg2KneClENcvKHyZDSjedfo3NM9TrFITFDR601
         yQqx14wXERKm0x996nGgHYeVEhGtcUaYUHN307CemMkPIRGRPcPeuwq2KGgUUy02ioLI
         laRC1oxaeOPZxzmAjbgHrR1CajM9yWhxOND3w=
MIME-Version: 1.0
In-Reply-To: <20091001085002.1dbc7eee@hyperion.delvare>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	 <20090928131700.GA19243@nb-core2.darkstar.lan>
	 <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>
	 <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>
	 <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>
	 <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
	 <4AC21E7B.70000@mandriva.org>
	 <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com>
	 <20091001085002.1dbc7eee@hyperion.delvare>
Date: Thu, 1 Oct 2009 08:40:59 -0600
Message-ID: <51f3faa70910010740s2a412d07qf29f56ad8a3c59eb@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Robert Hancock <hancockrwd@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Thomas Backlund <tmb@mandriva.org>, Luca Tettamanti <kronos.it@gmail.com>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       astarikovskiy@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 1, 2009 at 12:50 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Wed, 30 Sep 2009 17:38:21 -0600, Robert Hancock wrote:
>> On Tue, Sep 29, 2009 at 8:49 AM, Thomas Backlund <tmb@mandriva.org> wrote:
>> > Try this one:
>> > http://marc.info/?l=linux-kernel&m=125421276407283&w=2
>>
>> With that patch it's lasted almost a day with no timeouts, previously
>> I was getting about one every hour. Has that patch been submitted?
>
> Do you mean you're still getting timeouts but they are less frequent,
> or you did not get any timeout at all so far?

So far no timeout at all (after about 36 hours).
