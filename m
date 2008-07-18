Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYGRLdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYGRLdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYGRLdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:33:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:50697 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbYGRLda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BBUOUDDE/t8GDkVOqFZwxgXJTyKKvFuODil8ugDo3k9JfzE/GYYl3M8VI4Xjkvf9kk
         73JKZLc0KxSBpwP/Xi46WZQgHAZ3JpPgS2cnh7PpCgTanKkBFd/3chcn3PgUyQ8UUbWZ
         bOGoNAl+Kyzp4DFIJbopZ69xkt9CGlq7Lalu0=
Message-ID: <ea8d860a0807180433j1dd1223dm307d02e4a157b0a1@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:33:28 +0200
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Intel Management Engine Interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4880782F.7030405@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
	 <874p6nsft5.fsf@basil.nowhere.org>
	 <ea8d860a0807180351q490deea1rdf61469057e79ac3@mail.gmail.com>
	 <4880782F.7030405@firstfloor.org>
X-Google-Sender-Auth: d914f3e552a01e76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/18 Andi Kleen <andi@firstfloor.org>:
> Marcin Obara wrote:
>> 2008/7/18 Andi Kleen <andi@firstfloor.org>:
>>> How about the save oops data in HECI code? Will that be posted
>>> on top of this?
>>
>> This question was mostly already answered in
>> http://lkml.org/lkml/2007/12/11/166
>> In addition current MEI driver is for current platforms (AMT 3, 4, 5)
>> and have no AMT 1.0 legacy support.
>
> Well it didn't answer the question. Are you planning to submit
> code to store the oopses/kernel log based on this code or not?
>
> -Andi

For today... I have no such plans.

-- 
Marcin
