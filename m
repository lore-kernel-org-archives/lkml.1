Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYBFPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYBFPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYBFPZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:25:51 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:16097 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYBFPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:25:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Pri/NpwDa08NDkU7/0lGX86z48MzsuyzU1K5CJF5rskksTZWG1pg/B6Z+v0evFiz3W10FrrOWxblUTv19+DfSXHaFV/vAmfEcDD0PJ5oAWDC+vpFIS20tuZuqDJnDMJerFqs5WHU/5RYncirC3LnzRX2VJ3qxWgH1nqz7wXLQPI=
Message-ID: <47A9D14C.8000002@gmail.com>
Date: Wed, 06 Feb 2008 10:25:00 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: any cpu hotplug changes in 2.6.24-current-git?
References: <20080206125807.GB26817@elf.ucw.cz>
In-Reply-To: <20080206125807.GB26817@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> Are there any recent changes in cpu hotplug? I have suspend (random)
> problems, nosmp seems to fix it, and last messages in the "it hangs"
> case are from cpu hotplug...
> 									Pavel

Hi Pavel,
   Can you send along your cpuinfo?

-Greg
