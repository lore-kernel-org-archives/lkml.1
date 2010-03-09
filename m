Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0CIEQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 23:16:52 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44692 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab0CIEQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 23:16:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h/kgUTOPAk4+9u9Im7fOTUiCkCOY8gFu7Ml31/wMzDdGiuHONbXsdaGbs39+VhfNuZ
         e8ApLW/9lKVD1Dk88peXGhusmU9ZgyqxKGUjtIuSY3xHOyK+uEpVVs7r4qL68YgmaACM
         A3/xMMl1LlT9wGHx7J0wH4lAIJLDBNod2L9EA=
Message-ID: <4B95CBAA.50103@lwfinger.net>
Date: Mon, 08 Mar 2010 22:16:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: John Church <j.church@ymail.com>
CC: gregkh@suse.de, bzolnier@gmail.com, bernhard@schiffner-limbach.de,
       davem@davemloft.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix coding style issues in r8180_core.c
References: <1268099027-29438-1-git-send-email-j.church@ymail.com>
In-Reply-To: <1268099027-29438-1-git-send-email-j.church@ymail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 07:43 PM, John Church wrote:
> ---
>  drivers/staging/rtl8187se/r8180_core.c |   98 ++++++++++++++++----------------
>  1 files changed, 49 insertions(+), 49 deletions(-)
> 

Your efforts are appreciated; however, fixing coding style issues are just like
rearranging the deck chairs on the Titanic.

A mainline version of this driver, which is patterned after the rtl8180/8185
driver and using mac80211, is very nearly running. It is receiving data and able
to associate. It falls on its face when sending long packets, but I hope to
solve that difficulty soon.

I will keep you in mind as a possible tester when the new driver is working.

Larry

