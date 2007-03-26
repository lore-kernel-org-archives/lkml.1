Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXCZPpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXCZPpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXCZPpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:45:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:40535 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXCZPpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Gl/UQnEVOInFeaLK9NBkVIUctU9+6BWpNwvnD843zDHJWB033zbrxpeXKC3GGHG+jl43wPxQcxdG0uDStbEajLx6rsbOXNh+AWSuakhTtSA4lSi0eBiYV/OAVQI5b4cJ1AeH6WRxFXyD5LIOHBQwWKQ957BV0ULL/lqQgGev20I=
Message-ID: <75b66ecd0703260845r64860512t29e441b111875e11@mail.gmail.com>
Date: Mon, 26 Mar 2007 11:45:29 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [2.6.22 patch] more scheduled OSS driver removal
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <460776B2.3070404@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070324130602.GD752@stusta.de> <4607213B.9070005@student.ltu.se>
	 <75b66ecd0703252116m5216ec8dy78528f512ae63747@mail.gmail.com>
	 <460776B2.3070404@student.ltu.se>
X-Google-Sender-Auth: 712205e4fc09c578
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> > I guess he's referring to the well known "Master volume only controls
> > front output" problem.  This really does need to be resolved, as many
> > other ALSA drivers are effected.
> <rant_mode=on>
> Isn't this quite a basic feature?! Is there somewhere to monitor the
> progress on this?
> <rant_mode=off>

AC97 spec defines "Master" as controlling front outputs only.

But yes, there are proposals to improve the situation.  Search the
alsa-devel archives.

Lee
