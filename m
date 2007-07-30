Return-Path: <linux-kernel-owner+w=401wt.eu-S939237AbXG3Tf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939237AbXG3Tf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934892AbXG3Tfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:35:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:3840 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764103AbXG3Tfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ScB/Wv4MYAe3MaUqD3PPtas4asbW7b2RUHnm1Z/BMFc3cj1LA/+aJBpN1COjCShpfWoVJTQdJDUk7R1FsFlKnXPdcJhRewDrEBev3yO7NYfVKe7GW4TWnAJNdPtZvjzd1KpoDq6hN9Hk7TOn6VSSTkDdyXQCG+JZdXLsdmZUFv0=
Message-ID: <46AE3C80.7010307@googlemail.com>
Date: Mon, 30 Jul 2007 21:31:12 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       J.E.J.Bottomley@HansenPartnership.com
Subject: Re: Section mismatch warnings
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org>
In-Reply-To: <20070730185124.GA29116@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Jul 30, 2007 at 07:48:09PM +0200, Gabriel C wrote:
>> Hi Sam ,
>>
>> I get this warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-36 ) :
>>
>>
>> ...
>>
> I only looked at the Section mismatch warnings.
> They are fixed by following patch.

Wow you are fast :)

Yes all warnings are fixed.


Gabriel
