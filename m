Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbXD0WHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbXD0WHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbXD0WHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:07:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:56021 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXD0WGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CUDKKN8oYFN6B1yNmRC4y7oruZu2V7DzhkJHoOYBaV3NtwQ2XOqLM/PRZk6HiEWVTuno16frD3UTLTENagBFj+35/1oJahh2TrT/hUZgHRi5fxmtkDUhKMtbrE739onZ3pnP+0Q1+V/NNa4/YRX/wEvOTsV0C8jEk/BA/eO2f5U=
Message-ID: <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
Date: Fri, 27 Apr 2007 18:06:33 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Jon Burgess" <jburgess777@googlemail.com>
Subject: Re: [linux-dvb] Re: More than 2Gb problem (dvb related) ?
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Gregoire Favre" <Gregoire.Favre@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1177711220.26292.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070427111047.GB10284@gmail.com>
	 <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
	 <1177711220.26292.20.camel@localhost.localdomain>
X-Google-Sender-Auth: a06faba453dab6a5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/07, Jon Burgess <jburgess777@googlemail.com> wrote:
> Interesting - I see similar symptoms after upgrading my PC:
> * old PC was AMD Athlon 64 3000 w/ 2GB of RAM which had no issues
> * new PC is a Intel Core 2 Duo w/ 4GB of RAM and fails in the way you
> describe.

Driver using an incorrect DMA mask?

Lee
