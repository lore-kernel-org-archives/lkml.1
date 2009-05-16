Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZEPWwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZEPWwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZEPWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:51:56 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51041 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZEPWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UBjhvwMUziI6tA/MgS8Aok51sBVISgp6buBGVMR9skKNspeku62GvBU1gIIJwHcRfM
         0DJlTpYTLcsHdqDWb9ydZ38nLL6/AJpPEkbmt+1KY8UCt4Se/Ih2rVZxyG60Y7arBPZX
         qB6RIzrAHX2IXQTsF4ZZsggFCXlWC9czdWBQs=
Message-ID: <4A0F4388.9010502@gmail.com>
Date: Sat, 16 May 2009 16:51:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Isaacson <adi@hexapodia.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Subject: Re: [Bug #13179] CD-R: wodim intermittent failures
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.3ZB.GZzDKB@chimera>
In-Reply-To: <385Pu-agh7M.A.3ZB.GZzDKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13179
> Subject		: CD-R: wodim intermittent failures
> Submitter	: Andy Isaacson <adi@hexapodia.org>
> Date		: 2009-04-21 1:52 (26 days old)
> References	: http://marc.info/?l=linux-kernel&m=124027879214231&w=4

Last I heard the reporter was going to attempt to bisect the problem to 
see when the spurious udev events he was seeing started happening..
