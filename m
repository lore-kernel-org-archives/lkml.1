Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0CERmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:42:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:6471 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0CERml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rqf7FCed9Pg3LYEDPb3RNQ4q9Z05nsB+HuWHfOXJkrB5Hi0DkCAKcNzb/Lyx+DIeg9
         APRp9sHK0sfK/txsoTeV4gMLbCB9MKloqheOQULAy2h812T/ddUqEhqha8E12uaujnIL
         HU7kjOun+pAAUklQbQyvhmbFYisRxY2E4czzs=
Message-ID: <4B91428E.6070006@garzik.org>
Date: Fri, 05 Mar 2010 12:42:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [git pull] drm request 3
References: <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <20100305123834.0d9c6277@lxorguk.ukuu.org.uk> <20100305.063718.211238119.davem@davemloft.net> <20100305151754.GB2505@tempa>
In-Reply-To: <20100305151754.GB2505@tempa>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 10:17 AM, Daniel Stone wrote:
> On Fri, Mar 05, 2010 at 06:37:18AM -0800, David Miller wrote:
>> If it effects such a large number of people, which this noveau thing
>> does, it's entirely relevant to everyone.  And the way it's breaking
>> and making kernel development difficult for so many people matters to
>> us.
>
> Maybe the lesson to be learned from all this is, 'if the developers
> don't want something merged because they're not ready and forsee huge
> problems in the future, actually listen to them instead of blindly
> ramming it in regardless'? But maybe that's just me.

That particular horse left the barn when Fedora shipped nouveau in a 
stable release, not when Linus merged it into his tree.

	Jeff



