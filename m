Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131Ab0ACWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0ACWac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 17:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107Ab0ACWab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 17:30:31 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59506 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0ACWab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 17:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RDAV94CMndNrtPeyiIw1a4JcqwAow5Ox7OuK0cyEzyUhRKEck3tMQX4DF25dDhT9Ia
         6WR3vg3Z6Y4ueyDcmI0QWNDiWH4YyirCLJH6R4t4k8KiC7aRpbFWqwxX02KQ6NZ2Asm0
         b3BacecSB0no1qYgWr7MOtJVvTIfq6zqOGlq4=
Date: Sun, 3 Jan 2010 14:30:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: William Manson <WManson@synaptics.com>
Cc: Christopher Heiny <Cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
Message-ID: <20100103223025.GA4496@core.coreip.homeip.net>
References: <4B2D3B3A.2010308@synaptics.com>
 <4B2D3C53.8060908@synaptics.com>
 <20091220030512.GE4073@core.coreip.homeip.net>
 <7B4B50AC280A5E45A42CD2D364A3CE2F273406474D@USW-EX2K7-1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7B4B50AC280A5E45A42CD2D364A3CE2F273406474D@USW-EX2K7-1.synaptics-inc.local>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi William,

On Sun, Jan 03, 2010 at 11:48:55AM -0800, William Manson wrote:
> Hi Dmitry -
> 
> Thanks for the feedback - we really appreciate it. We are currently
> looking into the issues and the mailer-line wrap issue. We'll be
> re-sending a patch as soon as we get these issue resolved as soon as
> possible.

Could I also ask if you have any plans on extending support for the
newer models of your touchpads (especially multi-touch ones) in the PS/2
version of the driver? Or maybe there is updated version of the
Interfacing Guide that you could share with the community?

Thank you in advance,

Dmitry

