Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbYBOX3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbYBOX3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbYBOX3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:29:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:63391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYBOX3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:29:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=H+odPA5Pn8T6SvU61QrL0rOzPlHP9oeaf2n0fNsW9IphHPIZe8N6M4BhSkdKaelHRWM1j/tlgBB5Fj7WcXyPtQjHiwrjBvtgI4KboxY8POv87X3n7c51gwkWu6KP8q0qGib1XolzlBGedOR5Kep5rI3wwD7XA2VLHp7GJ2YNEiM=
Message-ID: <47B6205E.9030807@gmail.com>
Date: Sat, 16 Feb 2008 00:29:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>	 <1203109133-32217-2-git-send-email-jirislaby@gmail.com>	 <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com>	 <47B61473.7060206@gmail.com> <43e72e890802151524q4690f589hcc29ea8645b1d843@mail.gmail.com>
In-Reply-To: <43e72e890802151524q4690f589hcc29ea8645b1d843@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2008 12:24 AM, Luis R. Rodriguez wrote:
> On Fri, Feb 15, 2008 at 5:38 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> You mean to consider 0 as supported, -ENODEV/-EOPNOTSUPP as
>>  unsupported and the rest as error?
>>
> 
> Yeap, what do you think?

I have no opinion in this case, which one do you (all) like more?
