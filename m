Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbZJJTLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbZJJTLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 15:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762046AbZJJTLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 15:11:21 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:45908 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762039AbZJJTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 15:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=SfJBkWRQMps4K1fSVKZ+o8IV/Ro/BtjEfGsucg/F+LHtCczuqivC1c6s8OmdGYhUcs
         U0lcmmgSKQKoYtAqXXVFsnwtNXNckh7YY5mulC4FbQhiy9Evfw8arCseXXPveUjQt13Y
         4zJ1I7vTB+SW2UVcMbOrN9rW2Zu/CBkQ1q9QQ=
References: <4AD07F15.1060501@t-online.de>
Message-Id: <256BF4DC-F07C-4FF2-9DF6-E7C38083061D@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
In-Reply-To: <4AD07F15.1060501@t-online.de>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: Logitech Trackman FX detected as "Mouse"?
Date: Sat, 10 Oct 2009 12:10:32 -0700
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

On Oct 10, 2009, at 5:33 AM, Harald Dunkel <harald.dunkel@t-online.de>  
wrote:

> Hi folks,
>
> I just stumbled over this in logps2pp.c: My Logitech Trackman FX is
> detected as "Mouse" instead of "Trackman". dmesg shows
>
>    input: PS2++ Logitech Mouse as /devices/platform/i8042/serio1/ 
> input/input4
>

Please send me full dmesg of boot with i8042.debug so I can see the  
exact response the device produces.

Thanks!

-- 
Dmitry

