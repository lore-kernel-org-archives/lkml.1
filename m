Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbZCMWWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbZCMWWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZCMWWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:22:36 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58211 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbZCMWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AXVOVvJpakPh/y4QevwW9wq45Pfk4SfRPnN3GcZAQwFqYU3GP4WBxl68bYBjJ8OLLc
         fZ2hFcR91gCSpTVxSGS6IMIhV75acEo+sAKGKz8Hlb7kyVcdbfDibT5JYLAzPjjf9sw5
         8t3uKbMpTfHfYREvwee2/ysEmjxIFojaWIw24=
Message-ID: <49BADCA8.9020008@gmail.com>
Date: Fri, 13 Mar 2009 23:22:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc8
References: <alpine.LFD.2.00.0903122102510.3940@localhost.localdomain> <49BAD165.5020503@goop.org>
In-Reply-To: <49BAD165.5020503@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.3.2009 22:34, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
>> Ingo Molnar (1):
>> x86: work around Fedora-11 x86-32 kernel failures on Intel Atom CPUs
>
> I don't see a change titled this either in tip.git or linux-2.6.git. Did
> it get lost?

Did you forget to rebase/merge? I have it as
211b3d03c7400f48a781977a50104c9d12f4e229
in linux-2.6.git.
