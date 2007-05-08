Return-Path: <linux-kernel-owner+w=401wt.eu-S967440AbXEHNo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967440AbXEHNo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967136AbXEHNoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:44:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:48934 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967131AbXEHNoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:44:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pAPKzu5QXLqEDlJpTSBY0eG7MkmuJJsHXCy3eEdOo3fcqxvEZlO4/YgbhayYo1pli3jQ667f6eyz7n8hBN60iZd1nX/zcCaPl674rao3p/4pC78masE78Rz7N7eK0wkBEuCQC4Qi/BKOLqJ1ESk3mFVEE3n4K1YcYTJxAKjEOxA=
Message-ID: <97a0a9ac0705080644j664381daj20c64d070eaccc28@mail.gmail.com>
Date: Tue, 8 May 2007 07:44:23 -0600
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464034CF.20700@wpkg.org>
	 <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> I was always curious, why do people want to run ixp4xx in LE mode? What
> are the benefits that overweight the obvious performance degradation?

Debian on the NSLU2 runs in LE, and it is pretty popular.

http://www.linuxdevices.com/news/NS3535328630.html

Gordon

-- 
Gordon Farquharson
