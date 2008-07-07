Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYGGSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYGGSFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYGGSFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:05:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYGGSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:05:22 -0400
Message-ID: <48725A7F.7040409@kernel.org>
Date: Mon, 07 Jul 2008 11:03:43 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, webmaster@kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: git pull through http / git
References: <48724130.5050501@atmel.com> <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> I don't think many care about http downloading, just because it is 
> available as such.
> git:// and rsync:// are available though and should be usable even 
> without the http info that needs to be constantly refreshed when one 
> wants to use http....
> 

I thought rsync:// had the same problem (dumb transport) as http://.

I have made some sketches on a git-aware http protocol to deal with the 
"idiot IT department-managed firewall" problem; however, I have not had 
time to implement it.

	-hpa
