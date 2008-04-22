Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbYDVPAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbYDVPAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYDVPAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:00:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:52009 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762720AbYDVPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=coBHYPIUc802FlLm0uWZf0QkcdF5St0FZ84t5EHB7lcn7XkRLYCy5fdtpOSt7Mpy+0cBXk6TwUHpo3DwItLx5DYlCpwkd49Gst5+8steSyNKoEsBq+aEshODt3C2BDdjGaXz5A/DwPeUGAD2kS/au+r9LWcnviDUGtKdPJ2HBGs=
Message-ID: <480DFD7C.2030206@gmail.com>
Date: Wed, 23 Apr 2008 00:00:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca> <480DF876.7070800@gmail.com> <480DF9BD.1080104@rtr.ca>
In-Reply-To: <480DF9BD.1080104@rtr.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>> Ah.. that means we have the whole naming thing wrong.  Yewwww....
> ..
> 
> I suppose.   If we were needlessly pedantic, then perhaps
> the libata-bmdma.c should be renamed to libata-sff.c,
> and the libata-sff.c should be renamed libata-tf.c
> 
> But there's probably been a document or two since then,
> where the SFF folks have documented the TF interfaces, too.

Fingers and toes and whatever else crossed.

> So.. whatever.  :)

Yeah, that's the spirit.  :-)

-- 
tejun
