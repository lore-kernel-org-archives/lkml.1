Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZBJJTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZBJJTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZBJJTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:19:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:9354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZBJJTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZQundM12PcXdR4v3rv8v9StcC7kVAiTzqGTRgXLaasryEPKw4nnq+7Rv4Q5wV0+MGJ
         /9589XaDbfYnX+X1Vvj60yqCv9VqvAk2L7PtDl8Yz0iZ2jBYm7PHFyp7s0F7BpdOd8hU
         S3pSv93KZ2ebmTEYQR26BKKu1z8oF0Kr0On/A=
Message-ID: <49914688.3090509@gmail.com>
Date: Tue, 10 Feb 2009 10:19:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevice: ticks reaches 25, not 26.
References: <4990AC93.3080906@gmail.com> <20090209.175714.70463534.davem@davemloft.net>
In-Reply-To: <20090209.175714.70463534.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Mon, 09 Feb 2009 23:22:11 +0100
> 
>> With while (tick++ < 25) { ... } ticks reaches 25, not 26.
> 
> Does it?

Again, you're right, sorry, please ignore :-/
