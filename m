Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbZHRGqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbZHRGqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZHRGqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:46:30 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38245 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZHRGq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=g9JKxWZogobh1hqOj39cjaRGQU+83K6uDvSRWSkAubfDNmBySeWUIEJj7bQmDB8roI
         x69W+folHk3UN5tsCm3BIwicb9eZY58QMEAK4CLMfX/y275MyyOMLsCKzG710Anz3cHd
         axlqbZaJNTude9wMxKme1g7vWMHuqxw2Hhj/I=
MIME-Version: 1.0
Date: Tue, 18 Aug 2009 14:46:29 +0800
Message-ID: <63dd345a0908172346w36d7dc79s7964bc69b887bd97@mail.gmail.com>
Subject: Ooops! Can't booting kernel 2.6.26.8
From: hongqian <dhongqian@gmail.com>
To: linux-kernel@vger.kernel.org, pj@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all:

      I comiled and booted kernel 2.6.26.8 on Dell PowerEdge R710, It
reports Ooops, and halt down.

   The Ooops message is :

   Oops! Too many entries in the memory map
   Oops! Too many entries in the memory map
   Oops! Too many entries in the memory map
   ...
   PCI: Cannot allocate resource region 8 of bridge 0000:00:01.0
    ...
   PCI: Failed to allocate mem resource #8:40...
   ...

   kernel 2.6.28.9 is also can't be booted.  But it does't print out
Oops error message, It says exception.
