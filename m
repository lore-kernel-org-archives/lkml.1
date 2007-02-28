Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbXB1OeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbXB1OeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872AbXB1OeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:34:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:2204 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbXB1OeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:34:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YS8BKXT+snWU/K0tNNQ2xcWUpTk5ibQLxpVuFXV0Eh/KP1vseYdSMRCaMIi7oAGpxbs4iUsp0n0TDilRrlneAq6kLoBpID+2jqGZvA/UvLz5VzWHNNRP9/GXfab0mpURpHS+84Bmt+A40ghDYG/yzW6xigUhqfZ2kCIWaLFgKQc=
Message-ID: <75b66ecd0702280634r60ba05a1vce447bf0be1fb64f@mail.gmail.com>
Date: Wed, 28 Feb 2007 09:34:10 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Veronique & Vincent" <vinctre@videotron.ca>
Subject: Re: Sound 2.6.19: Soundcard driver often fail to load?
Cc: "Takashi Iwai" <tiwai@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200702272059.17644.vinctre@videotron.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702210550.48322.vinctre@videotron.ca>
	 <s5hk5y95da1.wl%tiwai@suse.de>
	 <200702272059.17644.vinctre@videotron.ca>
X-Google-Sender-Auth: af50d2c8b831fd7d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Veronique & Vincent <vinctre@videotron.ca> wrote:
> Maybie the Fedora team should use the asound.conf configuration instead?

This doesn't work for apps that use the deprecated /dev/dsp API.

Of course, a modern distro should be trying to purge these anyway...

Lee
