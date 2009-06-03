Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZFCEFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZFCEFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZFCEF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:05:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:50104 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZFCEF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wk5dlzSXg/4r4aGcvMDHUMPeGhKTF5QNwbc0DARhoBOsJlhQ/rgK12eGfhJwCLx4j7
         BqoV3NFYtRMYrGnQQFQbX0F6W8JyEpTX7doeiChH5qfufKoZsvQ9XlCvHDgDjpV2+Vau
         pQa1q/0T+jxR8PCbJtxPaw8BBFfTMlzbOIJK4=
Message-ID: <4A25F688.9000407@gmail.com>
Date: Tue, 02 Jun 2009 22:05:28 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Grozdan <neutrino8@gmail.com>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
In-Reply-To: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grozdan wrote:
> Hi,
> 
> I gave today kernel 2.6.30rc7 a spin on my Athlon 64 system and it
> seems there's yet again a problem with libata limiting IDE disks to
> UDMA33 since it thinks that the cable is only 40 wires. My distro
> kernel which is 2.6.27.21 does not have this problem and correctly
> sets my disks to UDMA133. I googled around and it seems in the past
> this was a known problem for some kernels. Any suggestions? :)
> 
> Please cc me as I'm not subscribed to the list

Full dmesg output from bootup would be useful.

CCing linux-ide.
