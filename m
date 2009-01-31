Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZAaBZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZAaBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZAaBZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:25:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:11739 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZAaBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:25:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=utfNqNIxunTiwCtnH2ugDDMNv3HTEZKJ+B2+EruaWEB8U/2DXS5uC6eohtfuZgo5Sw
         zweT5qkVfJosgI4kNYgXlyU1jxldfSXG8lskKWQUO62x4KfpcroZbvuchvGMDe9mlHAq
         aa3RFiXvIm7yBEBHZXvxVTGt7Jq1NEvXYCmMQ=
MIME-Version: 1.0
In-Reply-To: <4983A446.5080809@shaw.ca>
References: <77887e110901301623u746535f2q7dcc37cd40d2cc56@mail.gmail.com>
	 <4983A446.5080809@shaw.ca>
Date: Sat, 31 Jan 2009 02:25:11 +0100
Message-ID: <77887e110901301725p64f5ab4fk341a9bfaf6715a7b@mail.gmail.com>
Subject: Re: libata - anomaly performance with NCQ
From: Bartosz SKOWRON <getxsick@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 2:07 AM, Robert Hancock <hancockr@shaw.ca> wrote:

>> 1) cause the title contains "with hdparm"...does it mean that
>> physically the performance is OK and only hdparm shows something
>> wrong?
> Well, hdparm is a fairly crude benchmark but there's likely at least some
> impact in other usage.

It's not an answer for my question. So, should I check with other
benchmarks? I thought that this's issue is investigated and the answer
is common. Do you recommend any "not crude" benchmarks? :)


>> 2) there is an information about upgrading firmware. as far as i know
>> Seagate doesn't publish firmwares. So the only way is to contact
>> seagate support, send the hdd and wait for the new one?
> I think Seagate can provide firmware updaters for the user to use, but
> normally only if you contact support I think.

I will send the email cause there is no phone line for my country.
BTW. upgrade firmware == damage data?
