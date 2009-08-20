Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZHTHib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZHTHib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZHTHia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:38:30 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:40679 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZHTHi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gSwFU14BPm62Qgu4Z6niabyGNU+rOxXdYQfttROT7NchKv6Vei3PHKr0lC2eeTZ3Te
         0K4R0k3gZwtdRwF5AOQCuIBqDg1ehbf6URhwSmgGd9EmsR/nfXBhRNiJZhEDZGNYs6dS
         /HGigfSknpyt7xBu4hUno8ujoWEPjxfdKHpSo=
MIME-Version: 1.0
In-Reply-To: <Era7U-todKF.A.-rD.DoIjKB@chimera>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
	 <Era7U-todKF.A.-rD.DoIjKB@chimera>
Date: Thu, 20 Aug 2009 09:38:29 +0200
Message-ID: <38b2ab8a0908200038k2702109bp7e2d4b50e511d365@mail.gmail.com>
Subject: Re: [Bug #13328] b44: eth0: BUG! Timeout waiting for bit 00000002 of 
	register 42c to clear.
From: Francis Moreau <francis.moro@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 19, 2009 at 10:40 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13328
> Subject         : b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
> Submitter       : Francis Moreau <francis.moro@gmail.com>
> Date            : 2009-05-03 16:22 (109 days old)
> References      : http://marc.info/?l=linux-kernel&m=124136778012280&w=4
>

It hasn't triggered on 2.6.31-rc5 after a couple of days.

-- 
Francis
