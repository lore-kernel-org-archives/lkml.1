Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZIHGuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZIHGuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZIHGuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:50:50 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:48301 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZIHGut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QE9ZOFHlvwC7OaNtkIvuKjKEw6Ge9VKXwiythIr5tJZrkW3Vmg2u2hj+ywriotZJiY
         RefCkXAlVp6MAwm1WFkIXOcrPkGMTJT/dIK+V/49iZetVOm70nPCCFxDlUQSEbjW3MVF
         b1HxITtXA3g8mhIEfGrK6Y4OrqXtU5/JEAGAw=
MIME-Version: 1.0
In-Reply-To: <4AA24FAB.20700@panicking.kicks-ass.org>
References: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com>
	 <1252065236.14338.179.camel@skunk> <1252080405.24673.11.camel@mj>
	 <1252081080.31087.7.camel@skunk>
	 <43e72e890909040951y6a1e639bl771a63389665ca2a@mail.gmail.com>
	 <1252101647.11934.0.camel@bip>
	 <4AA24FAB.20700@panicking.kicks-ass.org>
Date: Tue, 8 Sep 2009 10:50:46 +0400
Message-ID: <a872555b0909072350qf105990q3efb99a8bbb2d0bc@mail.gmail.com>
Subject: Re: Atheros Linux wireless drivers home page - and two new driver 
	projects
From: Denis Kirjanov <kirjanov@gmail.com>
To: michael <michael@panicking.kicks-ass.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, devel@driverdev.osuosl.org,
       b_yogesh_snowy@yahoo.com, Dan Williams <dcbw@redhat.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       Len Widra <Len.Widra@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Stephen Chen <Stephen.Chen@atheros.com>,
       Jouni Malinen <j@w1.fi>, Nick Kossifidis <mickflemm@gmail.com>,
       Paul Fertser <fercerpav@gmail.com>, Harald Welte <laforge@openmoko.org>,
       Bob Copeland <me@bobcopeland.com>, Witold Sowa <witold.sowa@gmail.com>,
       Michael Renzmann <mrenzmann@madwifi-project.org>,
       Werner Almesberger <werner@openmoko.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good time of day.
Do I need to use wireless-testing tree ?

On Sat, Sep 5, 2009 at 3:46 PM, michael<michael@panicking.kicks-ass.org> wrote:
> Hi,
>
> Xavier Bestel wrote:
>>
>> Le vendredi 04 septembre 2009 à 09:51 -0700, Luis R. Rodriguez a écrit :
>>>
>>> On Fri, Sep 4, 2009 at 9:18 AM, Xavier Bestel<xavier.bestel@free.fr>
>>> wrote:
>>>>
>>>> On Fri, 2009-09-04 at 12:06 -0400, Pavel Roskin wrote:
>>>>>
>>>>> On Fri, 2009-09-04 at 13:53 +0200, Xavier Bestel wrote:
>>>>>>
>>>>>> On Thu, 2009-09-03 at 15:54 -0700, Luis R. Rodriguez wrote:
>>>>>>>
>>>>>>> I'm pleased to announce the new home page to Atheros Linux wireless
>>>>>>> drivers:
>>>>>>>
>>>>>>> http://wireless.kernel.org/en/users/Drivers/Atheros
>>>>>>
>>>>>> ath5k is marked as not master-mode capable. I thought this had been
>>>>>> fixed for 2.6.31 ?
>>>>>
>>>>> The above page makes no such statements.  I have fixed
>>>>> http://wireless.kernel.org/en/users/Drivers/ath5k
>>>>
>>>> Right, thanks.
>>>>
>>>>> https://madwifi-project.org/wiki/UserDocs/ath5kAccessPoint still needs
>>>>> a
>>>>> lot of work, or maybe it should be removed as obsolete.
>>>>
>>>> Yes, I miss access-point functionality in NetworkManager :)
>>>
>>> BTW a GSoC project this year was to add AP support to Network Manager.
>>> As far I can tell the Witold Sowa finished this so you should be able
>>> to test this.
>>
>> Awesome.
>>
>>> Witold, can you update the wiki page on this project with details as
>>> to how people can test this?
>>>
>>>
>>> http://wireless.kernel.org/en/developers/GSoC/2009/Add_AP_Support_to_Network_Manager
>>>
>>>  Luis
>>>
>
> Is there any plan to support the ar6k athereos wifi card?
>
> Michael
>
>>
>>
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>>
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Regards,
Denis
