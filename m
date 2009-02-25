Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbZBYWuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbZBYWuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZBYWul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:50:41 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:51231 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbZBYWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:50:40 -0500
Subject: [ANNOUNCE] OpenSUSE RT Kernel
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Novell
Date: Wed, 25 Feb 2009 14:50:33 -0800
Message-Id: <1235602233.19636.491.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For your information:

-------- Forwarded Message --------
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: opensuse-kernel <opensuse-kernel@opensuse.org>
Subject: [ANNOUNCE] RT Kernel
Date: Wed, 25 Feb 2009 14:47:37 -0800

RT Kernels are available for OpenSuse 11.1 and Factory.

The repos for latest version (current 2.6.29-rc6-rt3) are located here:

http://download.opensuse.org/repositories/Kernel://RT-devel/openSUSE_11.1/

http://download.opensuse.org/repositories/Kernel://RT-devel/openSUSE_Factory/


An older version (currently 2.6.26) is available here:

http://download.opensuse.org/repositories/Kernel://RT/openSUSE_11.1/

http://download.opensuse.org/repositories/Kernel://RT/openSUSE_Factory/


Finally, latest / experimental versions for 10.3, 11.0, 11.1 and Factory
are available in the repos below:

http://download.opensuse.org/repositories/home://sdietrich://Kernel-RT/


These Kernels generally correspond to the patch sets available at 

http://www.kernel.org/pub/linux/kernel/projects/rt/

There are minor modifications for integration with the Suse build
system, as well as additional features that we are working on.

Apparmor is not currently supported in the 2.6.29 variety, and has not
been tested on any Kernel version.

Due to the packaging-related (and possible other) variation from
upstream RT, please report bugs on the OpenSUSE forums, rather than to
the general RT community. 

http://bugzilla.novell.com/

We will sort them out accordingly.

Please CC me on bug reports and feature requests.

Regards,

Sven

