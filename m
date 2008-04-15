Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbYDOCkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbYDOCkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbYDOCkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:40:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:29665 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827AbYDOCkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fI1UwxUFwKhit8EGbTzJw30p3g9o8mfuc54RVVcfa7t6HRcOSCUgAZv0/B3dBhBpbj2347Zo/ADifi9FDy14bsJzrmP9X6Zdvn/BVQ2Ok0oU6Do5dOx+7JR4NvrraVCHTQXWUrYevqU8wV4scKsHLxkXocTUyhaJ4fZIM9unRog=
Message-ID: <480415A1.9090004@gmail.com>
Date: Tue, 15 Apr 2008 11:40:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: trenn@suse.de
CC: Rich West <Rich.West@wesmo.com>, Jeff Garzik <jeff@garzik.org>,
       Wander Winkelhorst <w.winkelhorst@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Peter Gervai <grinapo@gmail.com>, Marin Mitov <mitov@issp.bas.bg>
Subject: Re: sata_via
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>	 <47F6BD55.3090708@wesmo.com>	 <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com>	 <47F7982E.5080701@wesmo.com> <47F7F463.2060402@garzik.org>	 <480173CB.5070805@gmail.com> <480189DB.9050900@wesmo.com>	 <48018DC0.6080407@wesmo.com>  <1208133587.2755.8.camel@htj.dyndns.org> <1208160803.1784.14.camel@queen.suse.de>
In-Reply-To: <1208160803.1784.14.camel@queen.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> ----------------------------------------------
> Peter Gervai posted a similar report recently, Elias Oltmanns had an
> idea (on linux-ide or linux-acpi list):
> Subject: Re: Hard freeze / interrupt-related death / instability
> Wed, 09 Apr 2008
> 
> (but Tejun was already involved into that, at least in the link posted
> there, but reading it up might be worth it).
> Is this the same problem?

Can't really tell.  Didn't look like a low level driver problem tho.

-- 
tejun
