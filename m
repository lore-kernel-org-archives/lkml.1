Return-Path: <linux-kernel-owner+w=401wt.eu-S934571AbZLGPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbZLGPwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422AbZLGPwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:52:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:53401 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZLGPwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:52:24 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: [2.6.32.git] commit 1cedae7 breaks gdb
Date: Mon, 07 Dec 2009 07:54:25 -0800
Message-ID: <hfj8al$ni8$1@ger.gmane.org>
References: <4B1C5458.1030707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-192-22.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a1pre) Gecko/20091206 Thunderbird/3.1a1pre
In-Reply-To: <4B1C5458.1030707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2009 05:03 PM, walt wrote:
> Hi guys.  This commit:
>
> commit 1cedae72904b85462082dbcfd5190309ba37f8bd
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Wed Dec 2 07:32:16 2009 +0100
>
> hw-breakpoints: Keep track of user disabled breakpoints
>
> breaks debugging with gdb (at least gdb-7.0, anyway).

For the record, this bug is fixed in the thread
[GIT PULL] hw-breakpoints fixes. (Less than one day!)

Thanks Frederic!

