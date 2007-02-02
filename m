Return-Path: <linux-kernel-owner+w=401wt.eu-S1945935AbXBBPbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945935AbXBBPbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945938AbXBBPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:31:37 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:21036 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945935AbXBBPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d40fAXMQpGGTf9/68Q+/2mmakC6egSv5YRDl42RR7nyOxHZ2kFOZ8KVtg1KXU/le44mRSL0HT50UwYpA8xVchCQDJHoeb/KugmOA+Gu3YrmQ2/C0AbnsW2SOka9ypMFevaFs0P+ATP4gsdcH7AK1LNyXjWpMMWW2lnBikQLCI4g=
Message-ID: <38b2ab8a0702020731w6b41bee3qd150bc2f92bce20d@mail.gmail.com>
Date: Fri, 2 Feb 2007 16:31:35 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Subject: Re: Slower CPU frequency reported by the kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070202153327.1a06cffd@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	 <20070202130408.05212b10@localhost>
	 <38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
	 <20070202153327.1a06cffd@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Paolo Ornati <ornati@fastwebnet.it> wrote:
> Anyway it is started by an init script, so you should find it looking
> at "ls /etc/init.d/".
>

thanks for these information. I'm using a Fedora distrib and it
actually uses 'ondemand' governer with the cpu I use.

-- 
Francis
