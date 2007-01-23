Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbXAWPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbXAWPFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXAWPFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:05:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:35671 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXAWPFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e54eR9b1k3kLgjaT9UVMvQ5S7Q4pzDxwIkafUSt8LNzWbi8gaOW8GdbCJ0Fi9mRRZUwCQUVH+pTeK0HULQTaBy5rhGTvpkszV/npjaDxYowQoS1fGtcaYzs3eqHZ161aABlCti+NrBLVdf1dHv76fgCWbcmyukiQ6HGjZcEEFyA=
Message-ID: <3877989d0701230705t18893d0ft79e697e61ea1e81c@mail.gmail.com>
Date: Tue, 23 Jan 2007 23:05:33 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Jean-Marc Valin" <jean-marc.valin@usherbrooke.ca>
Subject: Re: Suspend to RAM generates oops and general protection fault
Cc: "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45B62163.4040704@usherbrooke.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <45B422D3.9040409@usherbrooke.ca>
	 <1169436221.2190.13.camel@nigel.suspend2.net>
	 <45B448BA.70800@usherbrooke.ca> <20070122132545.GA4493@ucw.cz>
	 <45B59239.90403@usherbrooke.ca>
	 <3877989d0701222311u5660a3c1id06bbeea3578a1c3@mail.gmail.com>
	 <45B62163.4040704@usherbrooke.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Jean-Marc Valin <jean-marc.valin@usherbrooke.ca> wrote:
> Luming Yu a écrit :
> > what about removing psmouse module?
>
> Trying that now. Any particular reason you suspect that one?
>

I suspect it is due to broken modules. If not psmouse, please trying a
boot with minimal modules loaded, and re-test .

Thanks,
Luming
