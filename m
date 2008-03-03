Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYCCUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYCCUNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760370AbYCCUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:12:31 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:3409 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbYCCUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=toLgcrO5Ljx44Cq73AYUKHw6AHARKyUP2I99bmZQ5tIUcraoydpgS031ktUWldVtoNLFm1DuZbAv9fJWQTHst21f4yx0aWHcBpgJD7mKQsRXcyt7fF7rwd8WQ2DxPzhi8RrdTR5NQsIStYz2x8oSSFps/krLkPxAMEzjvvsT5Sc=
Message-ID: <47CC5BA8.2050609@gmail.com>
Date: Mon, 03 Mar 2008 21:12:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uml: replace remaining __FUNCTION__ occurance
References: <1204572702.3266.48.camel@brick>
In-Reply-To: <1204572702.3266.48.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2008 08:31 PM, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
[...]
 >--
 > 1.5.4.3.500.g83a2c

please, use git send-email --thread
