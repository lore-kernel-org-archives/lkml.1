Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbZDHI2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbZDHI2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZDHI1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:27:54 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25599 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZDHI1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:27:53 -0400
Date: Wed, 8 Apr 2009 10:26:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ibmaem: Automatically load on HC10 blade
Message-ID: <20090408102632.1a85a151@hyperion.delvare>
In-Reply-To: <20090407205153.GA8311@plum>
References: <20090407205153.GA8311@plum>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, 7 Apr 2009 13:51:54 -0700, Darrick J. Wong wrote:
> Enable auto-probing for the HC10 blade and amend the supported system list.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/ibmaem |    2 +-
>  drivers/hwmon/Kconfig      |    2 +-
>  drivers/hwmon/ibmaem.c     |    1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Jean Delvare
