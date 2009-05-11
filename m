Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZEKTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZEKTnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZEKTnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:43:03 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15060 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZEKTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:43:01 -0400
Date: Mon, 11 May 2009 21:42:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [GIT PULL] hwmon fixes for 2.6.30
Message-ID: <20090511214248.0e09d39b@hyperion.delvare>
In-Reply-To: <20090511193733.GA7967@plum>
References: <20090508205916.4478b06c@hyperion.delvare>
	<20090511193733.GA7967@plum>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Mon, 11 May 2009 12:37:33 -0700, Darrick J. Wong wrote:
> On Fri, May 08, 2009 at 08:59:16PM +0200, Jean Delvare wrote:
> > Hi Linus,
> > 
> > Please pull some hwmon subsystem fixes for Linux 2.6.30 from:
> > 
> > git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus
> > 
> >  drivers/hwmon/asus_atk0110.c |    2 ++
> >  drivers/hwmon/w83781d.c      |    3 ++-
> >  2 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > ---------------
> > 
> > Jean Delvare (1):
> >       hwmon: (w83781d) Fix W83782D support (NULL pointer dereference)
> > 
> > Luca Tettamanti (1):
> >       hwmon: (asus_atk0110) Fix compiler warning
> 
> Hi Jean,
> 
> Hmm... is the "Support HC10 in ibmaem driver" patch queued for 2.6.31?  As I
> recall you put it in your tree some time ago, but I haven't heard or seen it
> since then. :)

Yes, it is queued for 2.6.31. See:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/

-- 
Jean Delvare
