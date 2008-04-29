Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbYD2Jw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbYD2Jw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYD2Jwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:52:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:56781 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYD2Jws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:52:48 -0400
In-Reply-To: <20080428230637.GX5401@shadowen.org>
References: <20080428153122.a94d21ba.pj@sgi.com> <481637D7.8090000@dawes.za.net> <alpine.LNX.1.10.0804282351120.21466@fbirervta.pbzchgretzou.qr> <20080428230637.GX5401@shadowen.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <bbde4dbb04c0d77f846f0ed706a81530@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Paul Jackson <pj@sgi.com>, Rogan Dawes <lists@dawes.za.net>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: +patch Why these dot chars in scripts/checkpatch.pl?
Date: Tue, 29 Apr 2008 11:51:52 +0200
To: Andy Whitcroft <apw@shadowen.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah I was under the missaprehension that whitespace was allowed after
> the # but not before.  That seems to be flawed.

It is true for K&R C (so with -traditional cpp mode), but indeed
false for ISO C.


Segher

