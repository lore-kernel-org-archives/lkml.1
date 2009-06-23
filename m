Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZFWUgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZFWUgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZFWUf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:35:57 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58320 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZFWUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F3vC8GDiVaV2dRtxR20V+NfdY5ks1rCf82FJ7gCc70dybhCKcZGRkUAocqaD79k9T3
         lDprbkGZxAZusIavx6/EZ/G7DawWVydmW+TA2702b1RW8ChJGFbVqpd3igJNtsTaFXtK
         zWYeaWqHHe/Qn3p9S6Ev9f2G/SBweJX+Tq0jY=
Date: Tue, 23 Jun 2009 16:35:50 -0400
From: Tj Hariharan <tj.physicist@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-newbie@vger.kernel.org
Subject: ACPI: undefined processor 0?!
Message-ID: <20090623203527.GA634@TjsLaptop>
References: <c2c826570906231331rfddcc71o72480e45c9152528@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2c826570906231331rfddcc71o72480e45c9152528@mail.gmail.com>
User-Agent: Mutt/1.5.17-muttng (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi I am a user of arch linux. I compil my own kernel (from linus' git
tree). Now, as of about 2 days ago, my syslog has been getting spammed with
the following message:

"Jun 23 11:37:38 TjsLaptop logger: ACPI group/action undefined: processor /
CPU0"

Can anyone tell me as to the reason for this. ACPI seems to work fine
otherwise. /proc/acpi is populated like it always is, as far as i can tell
everything is where it should be in there. (Including a
/proc/acpi/processors/CPU0, its there and working).

Thank you in advance.
-- 
-Tj (Tejas Hariharan)
 Tj@archlinux.us
 
