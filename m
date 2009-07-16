Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbZGPRZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbZGPRZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbZGPRZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:25:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58743 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815AbZGPRZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:25:14 -0400
Message-ID: <4A5F623A.80907@zytor.com>
Date: Thu, 16 Jul 2009 13:24:10 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com> <4A526D38.7000803@zytor.com> <20090707103723.GD5668@aftab> <4A537010.3050905@zytor.com> <20090708111911.GC19315@aftab> <20090716165136.GA31204@aftab>
In-Reply-To: <20090716165136.GA31204@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> any comments on that one, NAK/AK? Since it is a fix and not changing the
> interface to external users, it might be a good idea to include it in
> 2.6.31, IMHO, no?
> 

Yes, I also don't think it's a rush, so I'll take care of it when I get 
back from OLS.

	-hpa
