Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYFGKuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYFGKuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYFGKub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:50:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:46988 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbYFGKua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gsQMpSS22ihjLONnRtPvv8mgVqNnQsKjsStKw5DnPT7UFE2lIv3q/ayY+cJIFk7t88
         Qq/6QMqcjVO5ke6yxFOZdIVzfmEIRz4kLmypvyGiZODaHP0rk/vp04D7jSyVrIqYHOOQ
         hTQ1q7X/h4RIKPCIJx64f8XJDZ36TElXz93QM=
Message-ID: <84144f020806070350v51c4925chd74fe576c24078ac@mail.gmail.com>
Date: Sat, 7 Jun 2008 13:50:27 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook Pros
Cc: "Andrew Morton" <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mzxreary@0pointer.de
In-Reply-To: <20080607101433.GA572@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607025436.GB24254@srcf.ucam.org>
	 <20080606230745.304d116b.akpm@linux-foundation.org>
	 <20080607095839.GA803@srcf.ucam.org>
	 <84144f020806070305q33dd341wfbb36138d7b533a@mail.gmail.com>
	 <20080607101433.GA572@srcf.ucam.org>
X-Google-Sender-Auth: cb3de945cef981fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 1:14 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> If that's not sufficient, then the documentation needs fixing. It's also
> not current practice, as far as I can tell - did ath5k have sign-offs
> from the BSD people?

I don't know about ath5k. But when we submitted the IP1000 driver, we
had to contact the copyright holder (a company) and get proper
signoffs before Andrew acked the merge.
