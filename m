Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbZFNPWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbZFNPWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZFNPWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:22:10 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:32924 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZFNPWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:22:09 -0400
Message-ID: <4A35159E.7080004@xs4all.nl>
Date: Sun, 14 Jun 2009 17:22:06 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: crypt issue with 2.6.30/gcc 4.4.0?
References: <4A34FD06.2020204@xs4all.nl> <18997.5184.484019.744195@pilspetsen.it.uu.se>
In-Reply-To: <18997.5184.484019.744195@pilspetsen.it.uu.se>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2009 05:16 PM, Mikael Pettersson wrote:
> Udo van den Heuvel writes:
>  > How can I find out what's the cause for the password issue?
> 
> Instead of changing two variables at once (kernel version AND gcc version)
> you keep one constant and vary the other.
> 
> IOW, rebuild 2.6.29.4 with gcc-4.4 and test.
> Then rebuild 2.6.30 with gcc-4.3 or older and test.

I can do the 2.6.29.4 build with gcc-4.4 but the gcc-4.3 case is harder
to do: I need to convince Fedora to install a 2nd compiler-version (and
rest of toolchain).
I'll post back with the 2.6.29.4 results using gcc-4.4.

Udo
