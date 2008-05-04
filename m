Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYEDHmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYEDHmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYEDHmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:42:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:29109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYEDHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZY2EjnngkwSbiE7AX0wo7gk4oM3VAHI6u6yBSbm9H029Rt6j/23KF4OlqqhjU0xrjpYVxbFscRfyfmPv7FlLL7qChC0e9o7mRCUHTsUNCXlr90JdSEtgojnLA3YQhwlB7DkkYM5sOPeQ6VmuBaxjc2MrkTQxKnvyggYZfOTVL5E=
Message-ID: <481D68E0.1040608@gmail.com>
Date: Sun, 04 May 2008 09:42:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: npiggin@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nopage mm.h
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
In-Reply-To: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock napsal(a):
> Hello; I have a question about the nopage function that was removed in
> the kernel.
> What would be the best way for me to build a module that has a nopage
> funtion in it?

use .fault instead
