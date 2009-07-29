Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZG2GHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZG2GHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZG2GHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:07:54 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:58753 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZG2GHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p4SPqhrNjuFTiK4rOTF8e66b+vWHcs6XUKY4stY6IFOmxy1crYv8XPSe2Z+04ApQ/Z
         ZUacaHrBxXr2Cy60CggTgJg2wawtMEXM8TLv9F47LtqtbR22XmzFOTlTm1X1byAWR+l8
         O0Vkd3mv+uLjijeKpfgMfNrJ2xgwOBWxsyJ74=
Message-ID: <4A6FE740.7020302@gmail.com>
Date: Tue, 28 Jul 2009 23:08:00 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: CTRL-C functionality.
References: <241b8f7b0907282250k56807b83vba95ee9944d14edb@mail.gmail.com>
In-Reply-To: <241b8f7b0907282250k56807b83vba95ee9944d14edb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhu Chawandi wrote:
> Hi All,
>
>    where  exactly can I check for the above signal is caught properly
> or not.  How to enable ?
>
> Because when I do ctrl-c my linux application is not terminating, I
> want that signal to be cought.
>
> It is the customized linux for the STB, soon box starts running
> ctrl-C should teminate application.
>
> have any Idea, where I need to look-in.
>
> Thanks
> Prabhu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
showkeys is the command for bash
xev is for xserver.

Justin P. Matock
