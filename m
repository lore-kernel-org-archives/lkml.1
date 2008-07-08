Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYGHFcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYGHFcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYGHFc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:32:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:42796 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbYGHFc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KcGnEzMXoCn0Dg86mo58fzIFDd/sIh2HFl7tDgEHmLjenfl1J1RALJlkBRzKfTg3z9
         +7s2JVFGMXDMVSv42slqxLXE4hHSMQ+nOQFm7/hqew3Rov5EWYN+u0V2ycPZz2ptj5Ys
         rkGpabD/ZsDAC0RG7U95VXsYhlNhpMDPTDO3U=
Message-ID: <2c0942db0807072232q28e68cf4r32efff5fb48a9dbe@mail.gmail.com>
Date: Mon, 7 Jul 2008 22:32:26 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: david@lang.hm
Subject: Re: [PATCH][resubmit] HP iLO driver
Cc: "Altobelli, David" <david.altobelli@hp.com>,
       "Pavel Machek" <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
In-Reply-To: <alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080623160052.GA7616@ldl.fc.hp.com>
	 <20080627191458.GA10872@ucw.cz>
	 <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
	 <20080707160658.GB1794@elf.ucw.cz>
	 <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
	 <alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm>
X-Google-Sender-Auth: 978bac562b47b0ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 9:41 PM,  <david@lang.hm> wrote:
>> The message packets and documention are owned by hardware teams,
>> and they currently do not want to make that documentation public.
>
> umm, by merging the code a you reveal a lot of what they are attempting to
> keep secret. what's to stop someone from reading the code and writing the
> documentation?

I don't think you've read their driver. It presents barely more
structure to userspace than read and write.
