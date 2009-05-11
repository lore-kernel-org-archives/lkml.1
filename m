Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZEKThz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZEKThz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZEKThq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:37:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45708 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZEKThp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:37:45 -0400
Date: Mon, 11 May 2009 12:37:33 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [GIT PULL] hwmon fixes for 2.6.30
Message-ID: <20090511193733.GA7967@plum>
Reply-To: djwong@us.ibm.com
References: <20090508205916.4478b06c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508205916.4478b06c@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 08:59:16PM +0200, Jean Delvare wrote:
> Hi Linus,
> 
> Please pull some hwmon subsystem fixes for Linux 2.6.30 from:
> 
> git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus
> 
>  drivers/hwmon/asus_atk0110.c |    2 ++
>  drivers/hwmon/w83781d.c      |    3 ++-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> ---------------
> 
> Jean Delvare (1):
>       hwmon: (w83781d) Fix W83782D support (NULL pointer dereference)
> 
> Luca Tettamanti (1):
>       hwmon: (asus_atk0110) Fix compiler warning

Hi Jean,

Hmm... is the "Support HC10 in ibmaem driver" patch queued for 2.6.31?  As I
recall you put it in your tree some time ago, but I haven't heard or seen it
since then. :)

--D
