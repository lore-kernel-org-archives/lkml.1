Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbZLLAAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbZLLAAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZLLAAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:00:13 -0500
Received: from mail-yw0-f173.google.com ([209.85.211.173]:41613 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZLLAAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RlaPT9XzD1yro97xq1cHyXxYl7aD9OFhK7YYfFtIQcz+NUxUIEsVjB4bPz4eER3Zhq
         tbRHIdWm+0J4OdazMmXbXHsrEIRn30pYOyimTq4JJ/mj+tU3Z/pkVTgLegwNd3t6S0wK
         JK7Mvg3IsFHuuuZBMoCTSdgne3+vI0Oh+EAug=
Message-ID: <4B22DD11.7000905@gmail.com>
Date: Fri, 11 Dec 2009 18:00:17 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Christian Hartmann <cornogle@googlemail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: Q: Why I do have to restart alsa everytime after a resume from
    disk/ram ? Is this alsa- or kernel or config related??
References: <ffd8902a0912110121k795223ar6af644c41cd357b8@mail.gmail.com>
In-Reply-To: <ffd8902a0912110121k795223ar6af644c41cd357b8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 03:21 AM, Christian Hartmann wrote:
> hello list,
>
> everytime I suspended to disk or to ram, regardless of the used kernel
> (git or stable from distri), I must restart alsa to hear sound again.
> searched google and tried a lot but still the same awful behaviour.
> Has anybode some suggestions for me? is this alsa related ? or is this
> a kernel issue which could be dealt here?

I'm not sure what you mean by restarting ALSA, do you mean reloading the 
audio device module or something?

You didn't mention which kind of sound hardware you were using either..
