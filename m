Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYE0PEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYE0PEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYE0PEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:04:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:55856 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbYE0PEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WPnZs605LZOy7OXr6+hsI4Tz/FE5PsDmd2hMOqtUoVwr0krVUKAobTDiG1fXlCg6p4+0So6j8x5pCHbE2UWpDTZNJJHADIC5Qv8GQfc5RMzhWxEI+EQXxLiYrFnsLnIkWJg4zXntimKEr2TeeIvnl1hkKE13Ip51QcwK/aOalUI=
Message-ID: <dd18b0c30805270804p454a8fd9x2a0484c482c89440@mail.gmail.com>
Date: Tue, 27 May 2008 15:04:20 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: appletouch after wakeup
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200805271040.44203.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805262029me288690y237f995fb63ccf54@mail.gmail.com>
	 <200805271040.44203.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 8:40 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Dienstag, 27. Mai 2008 05:29:04 schrieb Justin Mattock:
>> Hello; with 2.6.26-rc3 I've notice appletouch is going out of whack,
>> here's what I see after waking the machine from suspend,
>> [ 8186.661313] appletouch: incomplete data package (first byte: 2, length: 4).
>> Keep in mind there is not just one of these messages, the entire dmesg
>> is filled.
>
> Immediately after resumption? STR or STD?
>
>        Regards
>                Oliver
>
>

I have to admit I don't know what STR or STD is for computer terminology!!
regards;

-- 
Justin P. Mattock
