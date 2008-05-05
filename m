Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbYEEVcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbYEEVcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYEEVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:32:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:13337 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbYEEVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oy/R9Nc+83PfqH0Y4yRJe5f1ssAHW9Ix9T3rqMAd8YwWz29OPokN7VJmmG7CQktNZH46CZUaRomrqyi/Y0QKkslHLe4gCftnhcRvuI5dvzCVm9loyGhLFYlKjd0uN85YJG/+16vRpU/cteF5Ir18dKEbc9/wBSuEUZCnI0n0ni8=
Message-ID: <30c6373b0805051432k2c5c3311vffb10fdf2a0ac1cd@mail.gmail.com>
Date: Mon, 5 May 2008 14:32:41 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: Ability to limit or disable page caching?
Cc: "Rik van Riel" <riel@redhat.com>, "FD Cami" <francois.cami@free.fr>,
       linux-kernel@vger.kernel.org
In-Reply-To: <481F7613.6040809@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	 <20080505212831.22371732@olorin>
	 <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	 <20080505164446.2ec9a543@cuia.bos.redhat.com>
	 <481F7613.6040809@nortel.com>
X-Google-Sender-Auth: 67b2d4d613d27a06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to be able to disable the cache altogether.....  It seems
like an easy tunable to add and might help benefit future testing.


-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
