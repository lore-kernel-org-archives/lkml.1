Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZHQGUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZHQGUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbZHQGUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:20:18 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:57988 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZHQGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=f1sNhWfNewwS8j0tmP0u/QaTzE8/FBAfAMreqcFw8PV8JjHC6qCHJnDuVDHHaIIf2H
         SFm5Tfeg9sJTTkjmyTvT5F80cKUAjcctOnN9auMtpr6mvFd3+cbJnz7gUZFBkaH8lO8f
         dYY3UCHKy1ugcvCWngzdl87R+EWWZbpPzzo/Y=
Message-ID: <4A88F6BF.7090104@gmail.com>
Date: Sun, 16 Aug 2009 23:20:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ohci1396_dma=early nogo on an imac?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems the macbook shows the init ohci1394_dma
activating, but using this on an imac has no affects.
is this device supported yet or is this still in the process of being
developed?(event though the imac is 1394 800 port).

At the moment my machine boots up 2.6.30.4 but will not bootup
the latest git. If the early dma option is possible with the imac9,1
I can send out a post with the error, and see if somebody might know.
(but if this isn't possible then Ill take the 40$
for the cable and and spend it on beer)...

Justin P. Mattock
