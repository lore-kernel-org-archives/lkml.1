Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbYBBRwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbYBBRwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYBBRvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:51:37 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:39072 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751856AbYBBRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:51:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bRHsfd2wQ79KdZzw7CmWUb3kO2TUquqB1jlRjiqlo3SeRPJ3VxriGIrzULt9Oz9d8Gw5alJiefHq3xlFlp2Qewd8V9vUDZWnUk9SaFDHpUetOcv5EdDoB8JI35E+8YrycUPSdex8KDwfycdfjAEVWmBXDW4NiYNTo0F3PhMVYYg=  ;
X-YMail-OSG: .p5Py5QVM1lNVNu2W2ta_l8df903wMCTw5fFW0QFzhtvbQQT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sat, 2 Feb 2008 09:51:29 -0800
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202124759.GB25773@elf.ucw.cz> <200802020931.38689.david-b@pacbell.net>
In-Reply-To: <200802020931.38689.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802020951.30071.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, David Brownell wrote:
>         static char *find_wake_rtc(void)
>         {
>                 char *pony = NULL;
> 
>                 dev = class_find_device(rtc_class, &rtc, has_wakealarm);
                                                     &pony,
... sorry, not all quadrupeds are named "rtc".

>                 return pony;
>         }
> 


