Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZFBMi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZFBMi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZFBMiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:38:50 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:47837 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZFBMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:38:49 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Seagate Barracuda 7200.11 ST31500341AS fw SD17
Date: Tue, 2 Jun 2009 14:38:50 +0200
User-Agent: KMail/1.9.10
Cc: Kay Diederichs <kay.diederichs@uni-konstanz.de>
References: <200906021258.20346.M4rkusXXL@web.de> <200906021337.03123.M4rkusXXL@web.de> <4A2517AD.1080509@uni-konstanz.de>
In-Reply-To: <4A2517AD.1080509@uni-konstanz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021438.50228.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1808DWqKWW6XzizclQPaLwpLPrvbH0eGeQtC2Uw
	BwtwEt4TScMBRtbgzXEO12BgedHbwwr8RDEkex3+2MA5W5Khms
	feZ7BH3gQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Diederichs wrote:
> Markus schrieb:
> > Rui Santos wrote:
> >>> I have some Seagate Barracuda 7200.11 ST31500341AS 1.5TB drives. 
They 
> >>> use the firmware SD17.
> >> Seagate recommends firmware SD1A for that HD.
> >> However, I do not know if it will solve your problem. Jut try it...
> > 
> >>> This drive+fw is blacklisted in the kernel, but there is no 
firmware 
> >>> upgrade for these drives. (Only very few serial numbers are able 
to 
> >>> upgrade.)
> > 
> > I cant upgrade the firmware because the flash-utility will abort due 
> > to "not affected serial number". I tried SD1B, the very newest 
version.
> > Cant find the SD1A for my drives.
> > 
> > Markus
> 
> I think you might have tried the wrong firmware file.
> ST31500341AS needs 
> 
http://www.seagate.com/staticfiles/support/downloads/firmware/Brinks-4D8H-SD1B.ISO

I tried that one (compared md5sum). It does not work. It only works 
for "ST31500341AS,  9JU138-300 or -336, SD15 through SD1A ONLY!"
So the utility fails and says the specific model could not be found.

Markus
