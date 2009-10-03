Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZJCCfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZJCCfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZJCCfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:35:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40773 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZJCCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:35:15 -0400
Message-ID: <4AC6B866.4000801@zytor.com>
Date: Fri, 02 Oct 2009 19:35:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matteo Croce <technoboy85@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
In-Reply-To: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 07:12 PM, Matteo Croce wrote:
> Hi,
> 
> the AMD GEode LX has an x86 id of 5 (i586) tought it's technically an i686:
> 

See checkin a7ef94e6889186848573a10c5bdb8271405f44de for additional details.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

