Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbYE0XXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbYE0XXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYE0XXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:23:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:36500 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYE0XXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qpn5F8Yx6S0OLJ7nrVFIOmGVA9RjXrNs2A8hZwwecNWqytjZ1qcl4gk0ctjKeXvP5Ar94Dx5i9RxsIvSqQpNs7Gjj05HHmu+gtCYVSj4Ej4cVv/hsChT6LOL5I0+onLjL5M+UmcnN29fQZzvd6UfalQjW6RIYV59ef7zPiUf5vo=
Message-ID: <6101e8c40805271623xb316cd0i47320ec566c0ba02@mail.gmail.com>
Date: Wed, 28 May 2008 01:23:06 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: madwifi && v2.6.26-rc4
Cc: mrenzmann@otaku42.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080527105123.1c154daf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40805270820r5984ceddmcc9ee1137e097b9e@mail.gmail.com>
	 <20080527105123.1c154daf@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jah, i know, that the ath5k is the official driver, but ath5k don't
supported WPA2-PSK.
I cc-ed mrenzmann, hi is the madiwifi webmaster / maintainer

On 5/27/08, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 27 May 2008 17:20:23 +0200
> "Oliver Pinter" <oliver.pntr@gmail.com> wrote:
>
>> Hi all!
>>
>> os: debian lenny
>> madwifi 0.9.3.3
>
>
> you probably want to use ath5k instead since you're posting to this
> list.....
>
>
>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>


-- 
Thanks,
Oliver
