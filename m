Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZLVQBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZLVQBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZLVQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:01:06 -0500
Received: from mail0.scram.de ([78.47.204.202]:55915 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZLVQBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:01:05 -0500
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2009 11:01:05 EST
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.357
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
Message-ID: <4B30E858.4010501@scram.de>
Date: Tue, 22 Dec 2009 16:40:08 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Davidlohr Bueso <dave@gnu.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: DIO bus driver usage
References: <20091216152755.GA18517@fencepost.gnu.org>
In-Reply-To: <20091216152755.GA18517@fencepost.gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

> I was doing some fixes to the DIO linux driver you wrote (drivers/dio/*) but was wondering if this driver is even in usage. I can't seem to see it compiled even using allyesconfig.

What $ARCH are you testing this on? The DIO bus in only available on m68k (hp300) machines.

Thanks,
Jochen
