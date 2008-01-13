Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYAMVc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYAMVc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYAMVcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:32:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:21109 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYAMVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u9Xn8CH2onj0gWrhM9SlAP7MdXpDfB7ad3fXHYiarXjlxG8LVGy3ar80rllRcSxcszM9GmTezSdeFARYPxACKfFlTkOOjYGFvmGyFi+/Jr4/qLzZ9QFW0Rb5IVtrjf0QTXoX35MaqVytl+nd6ezCWePPNh3iVPqrYQbmy0PA9Mg=
Message-ID: <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com>
Date: Sun, 13 Jan 2008 18:32:50 -0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Cc: "Paul Gortmaker" <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <478A82AD.3070904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com>
	 <478A82AD.3070904@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jiri. Will do that all tomorrow.
