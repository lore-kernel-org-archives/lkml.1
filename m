Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZG2GNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZG2GNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZG2GNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:13:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:47724 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZG2GNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kydaIJmpRpgFxpmX2z/1Re7aH1uoYA66x0Jixt3K7c2NkhIAjJG0EXjgZBmKCg4zot
         gM8cOifdyxvtj3XVZ9MptmdEuWz4xKked57BaFfizmyiJp+DlU8cms5em7Kwlnk+LzFh
         5sU1lsGWEDA8voIQ0JSwaSN8OXnpn6yzzhne8=
Message-ID: <4A6FE897.6010803@gmail.com>
Date: Tue, 28 Jul 2009 23:13:43 -0700
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
My bad, it's showkey not showkeys.

Justin P. Mattock
