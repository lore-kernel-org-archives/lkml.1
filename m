Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZEQH62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZEQH62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZEQH6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:58:18 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:55968 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZEQH6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O3TjbAXuh/P1c80BSj3dnZ+uBZ/UJFhpkww6TfZ4bwJlL8lfx44XrwfVagSWtMBcfI
         acf2C61anmCa4CR+OYEb/SVXyDi4/LNLicsGSJxzBGagvT22MToRF3LnqbwsJdNUn8e9
         IneNEZAXKKd8SkInUL7L/NWdvG7oyetVJvESY=
MIME-Version: 1.0
In-Reply-To: <pQ9WADCjgyE.A.gb.dD0DKB@chimera>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
	 <pQ9WADCjgyE.A.gb.dD0DKB@chimera>
Date: Sun, 17 May 2009 09:58:17 +0200
Message-ID: <8db1092f0905170058n338a3cbcr2a7524b11a22d21@mail.gmail.com>
Subject: Re: [Bug #12499] Problem with using bluetooth adaper connected to usb 
	port
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/16 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12499
> Subject         : Problem with using bluetooth adaper connected to usb port
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2009-01-13 18:34 (124 days old)
> References      : http://marc.info/?l=linux-kernel&m=123187185426236&w=4
> Handled-By      : Marcel Holtmann <marcel@holtmann.org>
>

2.6.30-rc6 works fine. Please, remove it.

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
