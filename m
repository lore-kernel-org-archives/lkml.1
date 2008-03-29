Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYC2RnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYC2RnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYC2Rmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:42:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38856 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYC2Rmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:42:51 -0400
Date: Sat, 29 Mar 2008 18:42:49 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Jacek Luczak <difrost.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
In-Reply-To: <47EE7C3A.5000909@zytor.com>
Message-ID: <alpine.LNX.1.10.0803291841540.28605@fbirervta.pbzchgretzou.qr>
References: <47EE75A0.8070705@gmail.com> <47EE7A66.30905@zytor.com> <20080329172551.GA9785@ZenIV.linux.org.uk> <47EE7C3A.5000909@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-03-29 18:28, H. Peter Anvin wrote:
>>
>>  Note that doing that makes sense only when you can expect additions to
>>  the end and even then it's a matter of taste.
>
> Yes, it is.
>
> I personally prefer it this way (strongly) for exactly the same
> reason C requires a semicolon at the end of each statement, as
> opposed to Pascal which doesn't require a semicolon immediately
> before an "end".

...as opposed to Perl which does not strictly require a ; at the
end of a block. :>

# while (1) { print 1; print 2 }
