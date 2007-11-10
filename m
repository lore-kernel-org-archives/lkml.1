Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbXKJMOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbXKJMOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 07:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXKJMOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 07:14:06 -0500
Received: from smtp02.cdmon.com ([212.36.74.229]:62104 "EHLO smtp02.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbXKJMOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 07:14:05 -0500
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2007 07:14:05 EST
Date: Sat, 10 Nov 2007 13:04:24 +0100
From: DervishD <lkml@dervishd.net>
To: Benny Halevy <bhalevy@panasas.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
Message-ID: <20071110120424.GA16067@DervishD>
Mail-Followup-To: Benny Halevy <bhalevy@panasas.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <4732E6BA.8060001@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4732E6BA.8060001@panasas.com>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Benny :)

 * Benny Halevy <bhalevy@panasas.com> dixit:
> I would like to hear peoples opinion about the indentation convention
> described below that I personally found the most practical with
> several different editors.

While I respect you opinion about tabs, I find tab indentation the most
evil thing ever invented. Even if done right (that is, not indenting
using a mixture of spaces and tabs), the only advantage is that you save
a few bytes.

So my opinion is: use spaces. The code indentation will look the same on
every editor no matter the tab settings.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
