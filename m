Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbYBMQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbYBMQT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYBMQTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:19:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:49439 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYBMQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=g48BxXI8Sa7W5IJMazTOCBAxqgumz97x+tufxIQ8zDLgYziiaHWN3xdti6pH3AYPYsV5lQmLpND8nT6ujHvEPNJfHCagmnXcLKNagbUvN8mU+lxfj81/ZcXnJu1knMQR5BIOzdauNrvDkwYpWSB1k0TR+EcZbM3I+xEluhklt1k=
Message-ID: <661de9470802130819i61dfe317jf3725a49d8a314b4@mail.gmail.com>
Date: Wed, 13 Feb 2008 21:49:14 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 updates
Cc: linux-kernel@vger.kernel.org, "Avi Kivity" <avi@argo.co.il>
In-Reply-To: <20080213155725.GA19523@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213155725.GA19523@elte.hu>
X-Google-Sender-Auth: 215467420c28aabd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, could you also please consider the KVM build fix at
http://marc.info/?l=linux-kernel&m=120262794315024&w=2 which has been
acked by Avi. I suspect this patch should be route through git-x86
since it affects arch/x86/Kconfig.

Balbir

PS: Modified cc's to reduce the noise.
