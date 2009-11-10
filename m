Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbZKJHEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbZKJHEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZKJHEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:04:06 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:34208 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZKJHEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:cc
         :content-type:content-transfer-encoding;
        b=MDH4wGS0DAjWOzlNxF20ZFi8uRDRg59VP7jsIh1i8o/qQUhGFrYHh8XlXWAXEPawBS
         OWAbUEhocutGZ8CWJB9M38G5rlFMcEHGTSMYk0Gy7SnH47CTEOF2hribWjuLDhyDXlXo
         LZ7F5TtYfokzOblcFFPBmw2HnnGnO/AQpLAiQ=
MIME-Version: 1.0
In-Reply-To: <3642a3130911092236p11ef0502se12788800c8d2084@mail.gmail.com>
References: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
	 <20091109175728.4eec67b9@lxorguk.ukuu.org.uk>
	 <3642a3130911092236p11ef0502se12788800c8d2084@mail.gmail.com>
Date: Tue, 10 Nov 2009 08:04:09 +0100
Message-ID: <3642a3130911092304x5c8fe8ddme1df39e6981cfe0a@mail.gmail.com>
Subject: Re: Kernel 2.6.29+ broke Cisco VPN Client
From: Mariusz Smykula <mariuszs@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 6:57 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> I must have imagined openconnect. Failing that you need to talk to your
> distro if they shipped the module or to cisco.

OpenConnect supports the new Cisco "AnyConnect" SSL VPN, not the old
IPsec-based VPN. Cisco ended support for this software and devices and
is not interested in helping us. All we have is open sourced cisco vpn
client which is broken since 2.6.29.

-- 
Mariusz Smykuła
