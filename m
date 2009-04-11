Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZDKWRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZDKWRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZDKWRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:17:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:56906 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbZDKWRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ePvEb6M81pOuUwuihadBBVlhn1jhhTMQ4pe7HxUJDmMoAyFdLU3wbav9Hze/ne6kA0
         3n8Jj1U2asRVReHgoGHO1VZIKFCStxZUaVPlY0IhE6rYy+2awZ9YpxaLRgbvUqAck/Os
         eKToRER4x3iGUpHOCxoRt1ue/NeLDfUdM7E30=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness with hotkeys
Date: Sun, 12 Apr 2009 00:17:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1; KDE/4.2.2; x86_64; ; )
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <49E10684.5090101@gmail.com>
In-Reply-To: <49E10684.5090101@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904120017.37469.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 of April 2009, Niel Lambrechts wrote:
> Hi there,
>
> With latest git kernel, I'm no longer able to control my Thinkpad (W500)
> brightness, although I can still control the backlight, bluetooth etc.

Same problem here (but no warning) on T400. I wasn't able to get it working. 
Tried using different values (0, 1,2, 3) for brightness_mode without success.

[ 7527.512263] thinkpad_acpi: ThinkPad ACPI Extras v0.22
[ 7527.512269] thinkpad_acpi: http://ibm-acpi.sf.net/
[ 7527.512274] thinkpad_acpi: ThinkPad BIOS 7UET61WW (2.07 ), EC 7VHT12WW-1.01
[ 7527.512279] thinkpad_acpi: Lenovo ThinkPad T400, model 2764CTO
[ 7527.526581] thinkpad_acpi: radio switch found; radios are enabled
[ 7527.526902] thinkpad_acpi: This ThinkPad has standard ACPI backlight 
brightness control, supported by the ACPI video driver
[ 7527.526909] thinkpad_acpi: Disabling thinkpad-acpi brightness events by 
default...
[ 7527.547485] Registered led device: tpacpi::thinklight
[ 7527.547747] Registered led device: tpacpi::power
[ 7527.547799] Registered led device: tpacpi::standby
[ 7527.554449] thinkpad_acpi: Standard ACPI backlight interface available, not 
loading native one.
[ 7527.554921] input: ThinkPad Extra Buttons as /class/input/input21


> Niel

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

