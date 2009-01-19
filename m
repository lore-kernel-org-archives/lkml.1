Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZASX3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZASX3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZASX3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:29:12 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35296 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZASX3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:29:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=TaLC5cAtr23PiObz2B+jPuWaXA3xdTNHgdfUFfA6vJ0boadvutTKSUzv38XC4nGTvC
         2uzR17Jj+ykN2JIfEUK1p6JsleC/z01D/zIDEqeUnxTnt9RdDuPggQIHhNZ4KkIdxgda
         UEynO4v8jG+MWuIf2+rOjAwix3IXKs6kmV9nQ=
Date: Tue, 20 Jan 2009 00:29:23 +0100
From: Diego Calleja <diegocg@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Faulty seagate drives, are going to be blacklisted?
Message-ID: <20090120002923.065f24ca@diego-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tech sites are reporting everywhere a massive flaw in seagate drives that
can lock up the drive and make it unusable (the bios doesn't detect it, you
can't read the data). Haven't read anything about it here on the lists.
Seagate has ack'ed the problem:
http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931

So, apparently there're a lot of drives on the market (including mine)
that can die any day. Are those drives going to be blacklisted? It's
still not clear if the firmware update is safe (some affected but
working drives are dying after the firmware update), so some people
like me is still waiting (and hoping that the drive doesn't die) for
more stable firmware updates...

Here is the list of drives+firmware affected, according to the support site
as of now. Some models are still being diagnosed.


Seagate Barracuda 7200.11 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207951)

Models Affected:
 ST3500320AS
 ST3640330AS
 ST3750330AS
 ST31000340AS
Firmware Affected
 SD15, SD16, SD17, SD18, SD19, AD14
Recommended Firmware Update
 SD1A

Seagate Barracuda 7200.11, page 2 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207957)
Models Affected:
 ST31500341AS
 ST31000333AS
 ST3640323AS
 ST3640623AS
 ST3320613AS
 ST3320813AS
 ST3160813AS
Firmware Affected
 Still Unknow
Recommended Firmware Update
 Still Unknow


Seagate Barracuda ES.2 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207963)
Models Affected:
 ST3250310NS
 ST3500320NS
 ST3750330NS
 ST31000340NS
Firmware Affected
 Still Unknow
Recommended Firmware Update
 Still Unknow

DiamondMax 22 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207969)
Models Affected:
 STM3500320AS
 STM3750330AS
 STM31000340AS
Firmware Affected
 MX15 (or higher)
Recommended Firmware Update
 MX1A

DiamondMax 22 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207975)
Models Affected:
 STM31000334AS
 STM3320614AS
 STM3160813AS
Firmware Affected
 Still Unknow
Recommended Firmware Update
 Still Unknow
