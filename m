Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZFEKpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZFEKpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFEKpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:45:09 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58666 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZFEKpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fDPlUlK0pbS0/k2JUPt7F7PCfND9ah3wJngTqR0kxMjCCNlsb7yCIYw61Jv73oQmRN
         Ek3HMJjfi5biWQNieko0HB/raOtxrFU3WTepc/at2v5hoBIu7jHrZA1OXFgYqj8OJPaM
         k0NGjjgf07h1rrfrD2md+1cKYbNijSjS4adZg=
MIME-Version: 1.0
In-Reply-To: <20090605094619.GB23085@build.ossfans.org>
References: <1244168990-28355-4-git-send-email-dbaryshkov@gmail.com>
	 <1244184737.22576.94.camel@johannes.local>
	 <20090605071529.GA7064@doriath.ww600.siemens.net>
	 <20090605.005418.07362083.davem@davemloft.net>
	 <20090605091229.GA25280@doriath.ww600.siemens.net>
	 <20090605094619.GB23085@build.ossfans.org>
Date: Fri, 5 Jun 2009 14:45:06 +0400
Message-ID: <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of 
	802.15.4 devices
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Sergey Lapin <slapin@ossfans.org>
Cc: David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/5 Sergey Lapin <slapin@ossfans.org>:
>> @@ -0,0 +1,523 @@
>> +/*
>> + * Netlink inteface for IEEE 802.15.4 stack
>> + *
>> + * Copyright 2007, 2008 Siemens AG
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2
>> + * as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along
>> + * with this program; if not, write to the Free Software Foundation, Inc.,
>> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>> + *
>> + * Written by:
>> + * Sergey Lapin <sergey.lapin@siemens.com>
> Dmitry, please toss all my @siemens.com addresses from all patches, since my
> access is already disabled and it's pointless to have invalid emails
> in source tree. Please replace them with @ossfans.org ones.

Could you please send an incremental patch on top of this serie? I
hope that my last
push can be pulled/merged and I don't want to redo all commits.


-- 
With best wishes
Dmitry
