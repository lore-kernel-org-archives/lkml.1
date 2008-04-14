Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbYDNQ1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbYDNQ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbYDNQ1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:27:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbYDNQ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:27:30 -0400
Message-ID: <4803851A.8090206@zytor.com>
Date: Mon, 14 Apr 2008 09:23:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <47FFD3F3.50107@redhat.com> <821384.64293.qm@web52504.mail.re2.yahoo.com> <20080411213843.GH2160@csclub.uwaterloo.ca> <4802608A.3040901@zytor.com> <20080414151222.GF7385@csclub.uwaterloo.ca>
In-Reply-To: <20080414151222.GF7385@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Sun, Apr 13, 2008 at 12:35:38PM -0700, H. Peter Anvin wrote:
>> "Any machine with spread spectrum clocking" is a pretty outrageous 
>> claim, since that includes just about 100% of all machines built today 
>> -- it's virtually impossible getting RFI certification without it.
> 
> True, but usually they give you an option to turn it off in the BIOS to
> make the system actually work with things like NTP.
> 
> Maybe I should have said "Any system with spread spectrum enabled".
> 

That, too, is clearly unrealistic, or NTP would be useless except on 
dedicated systems.

	-hpa
