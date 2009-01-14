Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZANXlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZANXlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758082AbZANXlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:41:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48967 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbZANXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:41:10 -0500
Message-ID: <496E782E.5020900@zytor.com>
Date: Wed, 14 Jan 2009 15:41:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, harvey.harrison@gmail.com,
       sam@ravnborg.org, jaswinderrajput@gmail.com
Subject: Re: [patch 0/5] x86 -tip: headers cleanup
References: <496e4e23.0305560a.4545.ffffaf3c@mx.google.com>
In-Reply-To: <496e4e23.0305560a.4545.ffffaf3c@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Small series of headers cleanup, easy to bisect.
> make headers_check still complains about vars
> being found in comments but this is just a false
> alarm. Please review.

Applied patch 1 to tip:x86/setup-lzma, and patches 2, 4 and 5 to 
tip:x86/header-fixes.

I'm holding off on patch 3 until we can get feedback on it.

	-hpa
