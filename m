Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbYCGI6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbYCGI6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYCGI6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:58:43 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:38171
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYCGI6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:58:43 -0500
Message-ID: <47D10324.8010007@qumranet.com>
Date: Fri, 07 Mar 2008 10:56:04 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Balaji Rao <balajirrao@gmail.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Mark kobjects as unitialized
References: <200803062223.18857.balajirrao@gmail.com>	<20080306170514.GA13839@suse.de>	<200803062320.50296.balajirrao@gmail.com> <20080306180559.GA14934@suse.de>
In-Reply-To: <20080306180559.GA14934@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> and is on my TODO list, slowly getting
> closer to the top...
>
>   

Strange.  On my TODO list, things slowly get pushed to the bottom.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

