Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYBEIyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYBEIyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbYBEIyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:54:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:7016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbYBEIyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mN0aAYyS66lujrzFAwnbWRjtsfBzQBwUnMUVnmKqF2Goy6HtCpJf6zHDIdlE7q01fX1ftkUuqHO/QSgyoRZ1mvfNEJjFf5M/yxXDO3z3v0K8ih6MjHVZs4J5kzIWMUq6zFDeZxdClXVJkUWdlqbwU8NFkNf8r0b6YCRGDW4jrNE=
Message-ID: <47A82443.9000601@gmail.com>
Date: Tue, 05 Feb 2008 09:54:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oliver Pinter <oliver.pntr@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Bruno Randolf <bruno@thinktube.com>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ath5k-devel@lists.ath5k.org
Subject: Re: [Wireless, ath5k] 2.6.24-git13 9135f1901ee6449dfe338adf6e40e9c2025b8150
References: <6101e8c40802040600q804e40cs97d0031920e58d9d@mail.gmail.com>	 <47A774AB.5060008@gmail.com>	 <6101e8c40802041334o20b2b391la5b0a5f557ee67c5@mail.gmail.com> <6101e8c40802041340g749b1e03k70fda7fdb21452d7@mail.gmail.com>
In-Reply-To: <6101e8c40802041340g749b1e03k70fda7fdb21452d7@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2008 10:40 PM, Oliver Pinter wrote:
> On 2/4/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
>> On 2/4/08, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> On 02/04/2008 03:00 PM, Oliver Pinter (Pintér Olivér) wrote:
>>>> [  413.118874] wpa_supplicant[4388]: segfault at 30 ip 080697ca sp
>>>> bfc9cab0 error 4 in wpa_supplicant[8048000+4c000]
>>> Seems like wpa_supplicant is broken. Is this a regression?
>> yes, but with madwifi is all ok

And this... madwifi goes through ported bsd net80211. So which latest git you 
tried worked for you when this is a regression, please?
