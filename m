Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYITJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYITJwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYITJwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 05:52:21 -0400
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:46635 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751267AbYITJwU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 05:52:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ucwwd8prL1QcmAEamPBG45pBAodZUNoxSLLv3N7bAadU+faXWgWFJQAt+YT0ECNy0eoR0BM8DGEKjhQyLn5lhXgNJmwxMNyXTv5kM63XyElJsV/pAQ+NBPi4aHYksMXGhKi2PAhA8npZQGKFMdzP0efJUdAdzZc7gkfcnk249x4=;
X-YMail-OSG: jGq8dvcVM1nSvxt5Ir1UFcR.l.zP6vniHoKIFFWARNjZi3YaQ3Boi5qldGqJTzsqWzhXSRDGgjxOg.XH7VHUoKU5XJZ5mcnRDmrdYfTC11LoVeCqlj44e.90Pyw07_D0Ocj3mLbhV3N4tnS9fKBIdIuFwrx_K7f.W_0NA0z0zSyTToY4UqY-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Sat, 20 Sep 2008 02:52:19 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: Re: Thinkpad T60p does not recover from Suspend when docked.
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48D3C67B.70909@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <509037.72884.qm@web52910.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 19/9/08, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> If you are using binary only graphics card drivers does the
> problem also happen without them never loaded at all?

I do know that it *does* suspend fine *with* the binary driver, provided the SATA drive isn't in the docking station, and that the laptop has been suspending fine like this for several months / kernel revisions.

I have never tried suspending the laptop *without* the binary driver, and so have no idea whether the display will unsuspend correctly.

> I had a machine that would not suspend properly until some
> time part way through the 2.6.25 kernel.

That's definitely not the case here.

Cheers,
Chris



      
