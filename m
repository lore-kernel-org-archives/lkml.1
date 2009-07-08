Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZGHCcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZGHCcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZGHCck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:32:40 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:61000 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZGHCck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Rxx0w71+xzifoVgVuh2QNekEK9DOuZq0u3fYOMg/xddLPJegRzmgkZZCYlHvIJ9BR6
         2ISVDR+BhwTHfDfWuLJQps+yS+cb4uGtLbS+bjeCurGR24EQAiuKz/Zl4tM/yhwhMD33
         ltijLY9un9vhR8QQQiI/VmxIOSwRt56dDv2og=
Message-ID: <4A540461.1030204@gmail.com>
Date: Tue, 07 Jul 2009 19:28:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: mactel-linux.org-users@queuemail.com
CC: mactel-linux-users <mactel-linux-users@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Mactel-linux-users] touchpad synaptics pm-suspend
References: <4A53C580.2040000@queuemail.com>
In-Reply-To: <4A53C580.2040000@queuemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

paul s wrote:
> hi -
>
> when my mbp4,1 comes back from suspend the touchpad is
> frozen|unresponsive|not working. it only seems to be with suspend as
> when it returns from hibernate it is fine...
>
> i am using 2.6.29.5-191.fc11.x86_64 is anyone experiencing this issue...
>
> i have been looking around, played with the fdi and also added a script
> to the /etc/pm/sleep.d to load and unload appletouch to no avail...
>
> cheers
> paul
>
> ------------------------------------------------------------------------------
> Enter the BlackBerry Developer Challenge
> This is your chance to win up to $100,000 in prizes! For a limited time,
> vendors submitting new applications to BlackBerry App World(TM) will have
> the opportunity to enter the BlackBerry Developer Challenge. See full prize
> details at: http://p.sf.net/sfu/Challenge
> _______________________________________________
> Mactel-linux-users mailing list
> Mactel-linux-users@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/mactel-linux-users
>
>    
have you tried the latest stable kernel?

Justin P. Mattock
