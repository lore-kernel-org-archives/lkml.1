Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbXEQEdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbXEQEdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbXEQEcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:32:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:64720 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbXEQEcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IXo9UdODYrAFT25j2iky8X/nW4A74pChRefac6XtW9N5+sP9ryRuZ5EQCk4F9zMPVLG2S+s4HI6ie0rv7reXwIRYGxD3J0o6SuUDg3Jr9fubCooC/JhJRbx1vK0fJqZoE41jejZLn/yA7IFEGlFzmOj/ejeE3KteFVZSyIPQcq4=
Message-ID: <2c0942db0705162132s2315ca18ra9da4974268d3096@mail.gmail.com>
Date: Wed, 16 May 2007 21:32:51 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] make hci_notifier a blocking notifier (was Re: BUG: sleeping function called from invalid context at net/core/sock.c:1523)
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Max Krasnyansky" <maxk@qualcomm.com>, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <a781481a0705162113w559ecbeesaba6bac0a92dc63b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705060816v59c1ae70m1d5067fcaba5a25d@mail.gmail.com>
	 <Pine.LNX.4.44L0.0705061801330.21407-100000@netrider.rowland.org>
	 <2c0942db0705061615i1c6147a1h6aca54012c3509aa@mail.gmail.com>
	 <a781481a0705061656u37b90022jfded9b1edbea3fa5@mail.gmail.com>
	 <2c0942db0705161209u5a0f1b8ay6864f9b9c4f7aac1@mail.gmail.com>
	 <a781481a0705162113w559ecbeesaba6bac0a92dc63b@mail.gmail.com>
X-Google-Sender-Auth: 8d3203d6d94c51e3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> This issue has actually been resolved, see the patch at:
> http://lkml.org/lkml/2007/5/16/149

Ah, excellent. Thanks!

Ray
