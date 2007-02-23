Return-Path: <linux-kernel-owner+w=401wt.eu-S1750716AbXBWFQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750716AbXBWFQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 00:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXBWFQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 00:16:35 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:36085 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXBWFQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 00:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ptyf0K10qaXz9/6Ouk25ifoGgkDIAB8JFd6M8gtXNpdYBMIcGokQzJLfn/TsZU/E4Stvyr0K/lcwvGLO/wJ0prziQkRmdRZh0rlh3VBphyNbVkVr4UULUXleNM0WUnZxrllg9Skfn5lsBwjj8CcGMFuie26yhj/II8nhpIKPPEQ=
Message-ID: <45DE78B1.6060000@gmail.com>
Date: Fri, 23 Feb 2007 14:16:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Lukas Hejtmanek <xhejtman@mail.muni.cz>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG in 2.6.20-git15, Suspend to disk
References: <20070222230443.GA6342@mail.muni.cz> <200702230006.48037.rjw@sisk.pl>
In-Reply-To: <200702230006.48037.rjw@sisk.pl>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Hi,
> 
> On Friday, 23 February 2007 00:04, Lukas Hejtmanek wrote:
>> Hello,
>>
>> after some time I've tried to suspend to disk. It basically works but it
>> complains into log with the following message:
> 
> Tejun says it is known and he's going to fix it.

Patch went into libata-dev.  Will soon propagate to Linus's tree.

-- 
tejun
