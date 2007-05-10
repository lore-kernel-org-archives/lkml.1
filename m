Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbXEJQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbXEJQCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXEJQCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:02:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:47714 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbXEJQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Q1xYZg89k3r+l1eHbstQYmxofNs12aJRwI6OqnTbUxn+IEiK4hhASLAdS1z7M9jF+lYktYVTxih1Ogz2nx1twomapPxCPd3Zii4+TCxVdv1+UXPLyzVCWGGs7JF0luGkLCfsRK8Kn9WA8dgDZwxj6BiGq4BHgdgi4mkfMXSLMlg=
Message-ID: <4643416F.7040006@gmail.com>
Date: Thu, 10 May 2007 17:59:43 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
References: <464045F0.3040906@gmail.com> <200705082213.44042.linux@rainbow-software.org>
In-Reply-To: <200705082213.44042.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2007 10:13 PM, Ondrej Zary wrote:

> I fixed cdu31a some time ago - so it at least works.

Oh, okay, thanks, I missed that. When I last tested it (which I see is in 
fact well over a year ago) it "sort of" worked sometimes but was really flakey.

> I also have a Panasonic drive with controller integrated on a SB16 sound
> card but haven't tried it with Linux yet.

Current driver doesn't work. Or, again, very much didn't when I last tried it.

Rene.

