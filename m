Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXCVQR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXCVQR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933913AbXCVQR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:17:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:22113 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789AbXCVQRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Cs9y0/AFYeIXd/LtWxtRJqcGoF/lZ4S/77J/iTPijlbTnNdKomeHUroGu0MZRn9jTTDw0Z/Q7ywPT454QRh/w2oH/54Cjm6kyxp8OEFfe0qCq0xBF846RbSgq0/B8kJnf+makdEGxir6CWktkIID6o8Oy/ToNpiqzOm0/ClMbuI=
Message-ID: <75b66ecd0703220917w2fa7c6afs4817b689f8a2e98f@mail.gmail.com>
Date: Thu, 22 Mar 2007 12:17:54 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
Subject: Re: how can I touch softlockup watchdog on all cpus?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net>
	 <20070321164404.GF13218@redhat.com>
	 <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net>
	 <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com>
	 <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net>
X-Google-Sender-Auth: 0e64994110077a49
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, Cestonaro, Thilo (external)
<Thilo.Cestonaro.external@fujitsu-siemens.com> wrote:
> > Just disable the softlockup watchdog.
>
> Thx for your answer, but this is no option for me, as I said in my first post :(.

Sounds like you have a fundamentally incompatible set of requirements.

Why do you need the softlockup watchdog if you intend to induce soft
lockups on purpose?

Lee
