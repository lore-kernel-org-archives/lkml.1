Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0BDTAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:00:18 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:59208 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab0BDTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:00:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=afDP2zIs3EU2ok6cK+U+vQUKuJfVnVEXMhJN4mc+Bai6Qu7fASL0pcIpdQ6fE0HIT+
         HmTcmgxZMhIWzBb7/2MKML8EWnvYB1N304UCk37rc0vhZsfd8KNsH6mnoAC8Q8dxxB6O
         9b5HZh6Z6oT01an7io+VWUkpAjk052+CA/MR8=
Message-ID: <4B6B193D.4060106@gmail.com>
Date: Thu, 04 Feb 2010 21:00:13 +0200
From: Oleg Kutkov <elenbert@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Intercepting system calls
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
Maybe this question is often, but all post i found is too old and some 
things is wrong...
So, i need to intercept some system calls (socket calls) and make my own 
handler.
Is there legal, correct and clean way to do it, without hacking system 
call table ?
Thank.

Best regards,
Oleg.
