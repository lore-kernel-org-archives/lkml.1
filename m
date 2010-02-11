Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0BKUIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:08:17 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63831 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0BKUIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jBCPw751LWKJL6v/mNawBK0XVgbW6QaI4Z00OieJmDXLPeI/muABPXiG2WsOSGpqe4
         xaYT/sVfMUEFiS3fkcaCzZPGnNM3Hk5l8S7euJdds3I4mrkUjDJB4R4t1izwPSejj4lx
         1VdCP55a7HPxctga09zF8jDbe0wli95iHGLYg=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tao Ma <tao.ma@oracle.com>
Subject: Re: lockdep warning for iscsi in 2.6.33-rc6
Date: Thu, 11 Feb 2010 21:08:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4B7107CF.3060703@oracle.com>
In-Reply-To: <4B7107CF.3060703@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002112108.11657.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia wtorek, 9 lutego 2010 o 07:59:27 Tao Ma napisał(a):
> Hi Mike,
> 	I meet with a lockdep warning for iscsi in 2.6.33-rc6.
> the lockdep is attached.
> 
> Regards,
> Tao
> 

I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15278
for Your bug report, please add Your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
