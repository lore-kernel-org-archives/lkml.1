Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0BRJWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:22:14 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:42345 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0BRJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:22:11 -0500
Message-ID: <4B7D06B4.60706@simula.no>
Date: Thu, 18 Feb 2010 10:21:56 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi, eric.dumazet@gmail.com,
       hannemann@nets.rwth-aachen.de, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, ebiederm@xmission.com
Subject: Re: [net-next PATCH v4 3/3] net: TCP thin dupack
References: <4B7AAE6E.7080600@simula.no> <20100217.163338.54972301.davem@davemloft.net>
In-Reply-To: <20100217.163338.54972301.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 21 msgs/h 2 sum rcpts/h 27 sum msgs/h 3 total rcpts 889 max rcpts/h 40 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6F94C1E1A2FA110B0D1E76AF2787AD2D7DFBED91
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 16 total 20665 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 01:33 AM, David Miller wrote:
> From: Andreas Petlund <apetlund@simula.no>
> Date: Tue, 16 Feb 2010 15:40:46 +0100
> 
>> Major changes:
>>       -Renamed variables, ioctl and sysctl.
>>       -Added sysctl documentation.
>>       -Removed redundant allocation
>>
>> Signed-off-by: Andreas Petlund <apetlund@simula.no>
> 
> Patches #2 and #3 look the same, what's going on here?
> 
> Thanks.

The changes from v3 to v4 was basically in the naming. I 
changed names for the given variables both for patch #2 and
patch #3. The removal of the unneeded allocation was also
done for both patches. It seems also I have forgotten to 
include the general patch description for each patch. I will
fix this for the next round of changes.

Cheers,
Andreas


