Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZC1T3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZC1T3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZC1T3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:29:46 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:44517 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbZC1T3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:29:46 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Miller <davem@davemloft.net>
Subject: Re: Network died completely in 2.6.29
Date: Sat, 28 Mar 2009 20:29:35 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200903272351.37610.linux@rainbow-software.org> <20090327.155346.98210435.davem@davemloft.net>
In-Reply-To: <20090327.155346.98210435.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282029.37128.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009 23:53:46 David Miller wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
> Date: Fri, 27 Mar 2009 23:51:36 +0100
>
> > upgraded to 2.6.29 today. It appeared to work fine for a couple of hours.
> > But suddenly the network stopped. I wasn't even able to ping my local IP.
> > Even pinging 127.0.0.1 did not work. There were no errors in dmesg and
> > the system appeared to work fine otherwise. Had to reboot (into 2.6.28).
> >
> > Never seen this before. Anyone with the same problem?
>
> It's a known problem, the following fix will be submitted
> to 2.6.29.1 over the weekend.

Thanks, it seems to work now.

-- 
Ondrej Zary
