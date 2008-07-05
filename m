Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYGERfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYGERfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYGERf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:35:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:18710 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYGERfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:35:25 -0400
Message-ID: <cccedfc60807051035q52354cf0mbb471915b7b33d6b@mail.gmail.com>
Date: Sat, 5 Jul 2008 12:35:24 -0500
From: "Jon Nelson" <jnelson@jamponi.net>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, xfs@oss.sgi.com,
       "Alan Piszcz" <ap@solarrain.com>
In-Reply-To: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try booting with:

nolapic

That largely fixed my problems on my motherboard (2.6.18+, EPoX MF-570SLI).
I hope to try 2.6.25+ soon.

-- 
Jon
